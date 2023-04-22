module StabilityAI
    module Response
      class BaseResponse
        attr_reader :raw_response, :http_status
  
        def initialize(raw_response)
          @raw_response = raw_response
          @parsed_response = @raw_response.parsed_response
          @http_status = raw_response.code
        end
      end
    end
end
  