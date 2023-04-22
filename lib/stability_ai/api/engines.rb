module StabilityAI
    module API
      module Engines
        def engines_list
          response = self.class.get('/v1/engines/list')
          if response.code == 200
            StabilityAI::Response::EnginesListResponse.new(response)
          else
            error_data = response.parsed_response
            raise StabilityAI::StabilityAIError.new(response.code, error_data["id"], error_data["name"], error_data["message"])
          end
        end
      end
    end
end
  