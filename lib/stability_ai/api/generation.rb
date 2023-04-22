require "uri"
require "rmagick"

module StabilityAI
  module API
    module Generation
      def text_to_image(engine_id: nil, options: {})
        response = self.class.post("/v1/generation/#{get_engine_id(engine_id)}/text-to-image", body: options.to_json,
                                                                                               headers: { "Content-Type" => "application/json" })
        handle_response(response)
      end

      def image_to_image(engine_id: nil, image_binary: nil, image_base64: nil, image_path: nil, options: {})
        raise "No image file path provided." unless image_path || image_binary || image_base64
        raise "No prompt provided." if options[:text_prompts].nil?

        image_payload = create_payload(image_binary, image_base64, image_path)
        image =         convert_and_resize_image(image_payload)
        temp_file =     create_temp_file_from_image(image)
        form_data =     set_form_data(:image_to_image, options, temp_file)

        default_weight = options[:text_prompts].count > 1 ? (1 / options[:text_prompts].count).round(2) : 1
        options[:text_prompts].each_with_index do |text_prompt, i|
          form_data.merge!("text_prompts[#{i}][text]" => text_prompt[:text]) unless text_prompt[:text].nil?
          form_data.merge!("text_prompts[#{i}][weight]" => text_prompt[:weight] || default_weight) unless text_prompt[:weight].nil?
        end

        headers = { "Content-Type" => "multipart/form-data" }
        response = self.class.post("/v1/generation/#{get_engine_id(engine_id)}/image-to-image",
                                   headers: headers, multipart: true, body: form_data)
        handle_response(response)
      ensure
        if temp_file
          temp_file.close
          temp_file.unlink
        end
      end

      def image_to_image_upscale(engine_id: "esrgan-v1-x2plus", image_binary: nil, image_base64: nil, image_path: nil, use_maximum_resolution: false, upscale_options: {})
        raise "No image file path provided." unless image_path || image_binary || image_base64

        image_payload = create_payload(image_binary, image_base64, image_path)
        image =         convert_and_resize_image(image_payload)
        temp_file =     create_temp_file_from_image(image)
        form_data =     set_form_data(:image_to_image_upscale, upscale_options, temp_file)

        headers = { "Content-Type" => "multipart/form-data" }
        response = self.class.post("/v1/generation/#{engine_id}/image-to-image/upscale", headers: headers, multipart: true, body: form_data)
        handle_response(response)
      ensure
        if temp_file
          temp_file.close
          temp_file.unlink
        end
      end

      private

      def get_engine_id(engine_id)
        engine_id || StabilityAI.configuration.default_engine_id
      end

      def handle_response(response)
        if response.code == 200
          StabilityAI::Response::ImageResponse.new(response)
        else
          error_data = response.parsed_response
          raise StabilityAI::StabilityAIError.new(response.code, error_data["id"], error_data["name"],
                                                  error_data["message"])
        end
      end

      def create_payload(image_binary, image_base64, image_path)
        if image_binary
          StringIO.new(image_binary).read
        elsif image_base64
          StringIO.new(Base64.decode64(image_base64)).read
        elsif image_path
          File.read(File.open(image_path, 'rb'))
        else
          raise "No image binary, base64, or file path provided."
        end
      end

      def create_temp_file_from_image(image)
        temp_file = Tempfile.new(['image', '.png'])
        temp_file.binmode
        image.format = 'PNG' # Set the format explicitly before calling to_blob
        temp_file.write(image.to_blob)
        temp_file.flush
        temp_file.rewind
        temp_file
      end

      def get_image_dimensions(image)
        [image.columns, image.rows]
      end

      def set_max_dimension(image, upscale_options, use_maximum_resolution)
        if use_maximum_resolution
          width, height = get_image_dimensions(image)
          (width > height) ? { 'width' => 2048 } : { 'height' => 2048 }
       else
         case
         when !upscale_options[:width].nil?
           { 'width' => upscale_options[:width] }
         when !upscale_options[:height].nil?
           { 'height' => upscale_options[:height] }
         else
           nil
         end
       end
      end

      def set_form_data(endpoint, options, temp_file)
        raise "No image file provided." unless temp_file

        form_data = {}
        case endpoint
        when :image_to_image
          form_data.merge!("init_image" => temp_file)
          parameters = %w[image_strength, init_image_mode, cfg_scale, clip_guidance_preset, samples, steps]
          parameters.each do |parameter|
            next if options[parameter.to_sym].nil?
            form_data.merge!(parameter => options[parameter.to_sym])
          end
          form_data
        when :image_to_image_upscale
          form_data.merge!("image" => temp_file)
          max_dimension = set_max_dimension(image, upscale_options, use_maximum_resolution)
          form_data.merge!(max_dimension) if max_dimension
        end
      end

      def get_new_dimensions(width, height, step = 64)
        new_width = (width / step) * step
        new_height = (height / step) * step
        [new_width, new_height]
      end

      def convert_and_resize_image(image_payload)
        # Convert the input image to PNG format if it's a JPG or JPEG file
        image = Magick::Image.from_blob(image_payload).first
        image.format = 'PNG' if %w[JPG JPEG].include?(image.format)

        if image.columns % 64 != 0 || image.rows % 64 != 0
          # Calculate new dimensions
          new_width, new_height = get_new_dimensions(image.columns, image.rows)

          # Resize the image while maintaining aspect ratio
          image.change_geometry("#{new_width}x#{new_height}") do |cols, rows, img|
            img.resize!(cols, rows)
          end

          # Find the nearest multiples of 64 for both width and height
          width_multiple = (image.columns / 64.0).floor * 64
          height_multiple = (image.rows / 64.0).floor * 64

          # Calculate new offsets for cropping
          x_offset = (image.columns - width_multiple) / 2
          y_offset = (image.rows - height_multiple) / 2

          # Crop the centered part to ensure dimensions are multiples of 64
          image.crop!(x_offset, y_offset, width_multiple, height_multiple)
        end
        image
      end
    end
  end
end
