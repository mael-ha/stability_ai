module StabilityAI
  class Client
    include HTTParty
    include StabilityAI::API::User
    include StabilityAI::API::Engines
    include StabilityAI::API::Generation

    base_uri "https://api.stability.ai"
    format :json

    def initialize(api_key = nil)
      @api_key = api_key || StabilityAI.configuration.stability_api_key || ENV["STABILITY_API_KEY"]
      raise ArgumentError, "Missing Stability API key." unless @api_key

      self.class.default_options.merge!(
        headers: {
          "Authorization" => "Bearer #{@api_key}",
          "Content-Type" => "application/json",
          "Accept" => "application/json"
        }
      )

      set_default_engine_id
    end

    private

    def set_default_engine_id
      # Setting stable-diffusion-xl as default engine
      return if StabilityAI.configuration.default_engine_id

      engines_list_response = engines_list
      engines = engines_list_response.engines

      default_engine = engines.find { |engine| engine.id.include?("stable-diffusion-xl") }
      StabilityAI.configuration.default_engine_id = default_engine.id if default_engine
    end
  end
end
