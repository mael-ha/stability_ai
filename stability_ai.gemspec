# frozen_string_literal: true

require_relative "lib/stability_ai/version"

Gem::Specification.new do |spec|
  spec.name = "stability_ai"
  spec.version = StabilityAI::VERSION
  spec.authors = ["Maël Harnois"]
  spec.email = ["hey@maelus.com"]

  spec.summary = "Ruby wrapper for Stability AI API"
  spec.description = "This gem enables to interact with the Stability AI API and generate images."
  spec.homepage = "https://github.com/mael-ha/stability_ai.git"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/mael-ha/stability_ai.git"
  spec.metadata["changelog_uri"] = "https://github.com/mael-ha/stability_ai.git"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) || f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency "httparty", "~> 0.20.0"
  spec.add_dependency "dotenv", "~> 2.7.0"
  spec.add_dependency "rmagick"
  spec.version = "0.1.0"


  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
