module StabilityAI
    module Response
        class EnginesListResponse < BaseResponse
            def engines
                @parsed_response.map { |engine| OpenStruct.new(engine) }
            end
        end
    end
end
