module StabilityAI
  module Response
    class ImageResponse < BaseResponse
      attr_reader :artifacts

      def initialize(response)
        super(response)
        @artifacts = response.parsed_response["artifacts"]
        convert_artifacts_to_openstruct
      end

      def convert_artifacts_to_openstruct
        @artifacts.map! do |artifact|
          image_binary_data = Base64.decode64(artifact["base64"])
          artifact["image_binary"] = image_binary_data
          artifact.delete("base64")
          OpenStruct.new(artifact)
        end
      end

      def save_images(filename_prefix: nil)
        filename_prefix = Time.now.utc.strftime("%Y%m%d%H%M%S") if filename_prefix.nil?
        downloaded_images = []
        path_prefix = StabilityAI.configuration.path_prefix
        @artifacts.each_with_index do |artifact, i|
          image_name = "#{filename_prefix}_#{i}.png"
          image_path = path_prefix + image_name
          File.binwrite(image_path, artifact["image_binary"])
          downloaded_images << {
            file_name: image_name,
            seed: artifact["seed"],
            finish_reason: artifact["finish_reason"],
          }
        end
        downloaded_images
      end
    end
  end
end
