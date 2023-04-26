module StabilityAI
    class StabilityAIError < StandardError
      attr_reader :id, :name, :message
  
      def initialize(code, id, name, message)
        @code = code
        @id = id
        @name = name
        @message= message
        super("#{code}# #{name}: #{message} (ID: #{id})")
      end
    end
end
  