module StabilityAI
    module Helpers
      class ImageHelper
        def self.save_artifacts(artifacts, prefix = "output")
          artifacts.each_with_index do |artifact, i|
            save_base64_image("#{prefix}_#{i}.png", artifact.base64)
          end
        end
  
        def self.save_base64_image(file_path, base64_image)
          File.binwrite(file_path, Base64.decode64(base64_image))
        end
      end
    end
end
  