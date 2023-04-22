module StabilityAI
    module Response
      class UserResponse < BaseResponse
        def credits
          @parsed_response['credits']
        end
      end
    end
end
  