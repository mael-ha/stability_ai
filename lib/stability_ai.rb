# frozen_string_literal: true

require "httparty"
require "pry-byebug"
require "dotenv/load"
require "base64"
require "uri"
require_relative "stability_ai/version"
require_relative "stability_ai/api"
require_relative "stability_ai/api/user"
require_relative "stability_ai/api/engines"
require_relative "stability_ai/api/generation"
require_relative "stability_ai/client"
require_relative "stability_ai/response/base_response"
require_relative "stability_ai/response/user_response"
require_relative "stability_ai/response/engines_response"
require_relative "stability_ai/response/image_response"
require_relative "stability_ai/stability_ai_error"
require_relative "stability_ai/configuration"

module StabilityAI
  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Error < StandardError; end
end
