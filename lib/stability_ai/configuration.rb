module StabilityAI
    class Configuration
      attr_accessor :stability_api_key, :default_engine_id, :path_prefix
  
      def initialize
        @stability_api_key = nil
        @default_engine_id = nil
        @path_prefix = './'
      end
    end
  end
  