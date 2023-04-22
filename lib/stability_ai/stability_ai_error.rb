module StabilityAI
    class StabilityAIError < StandardError
      attr_reader :error_id, :error_name, :error_message
  
      def initialize(code, id, name, message)
        @error_code = code
        @error_id = id
        @error_name = name
        @error_message= message
        super("#{code}# #{name}: #{message} (ID: #{id})")
      end
    end
end
  