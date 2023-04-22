module StabilityAI
    module API
      module User
        def balance
          response = self.class.get('/v1/user/balance')
          if response.code == 200
              StabilityAI::Response::UserResponse.new(response)
          else
              error_data = response.parsed_response
              raise StabilityAI::StabilityAIError.new(response.code, error_data["id"], error_data["name"], error_data["message"])
          end
        end
      end
    end
end
  