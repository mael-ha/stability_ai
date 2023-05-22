# StabilityAI

StabilityAI is a Ruby gem that simplifies interactions with the Stability AI API. It supports image generation, image-to-image manipulation, upscaling, and masking.

## Demo

I made this `gem` part of a personal project: [ciel.chat](https://ciel.chat) - an AI supercharged WhatsApp bot, using ChatGPT, Bard, StableDiffusion, Dalle, GoogleSpeech, ElevenLabs.
You can try it there for free ✌️

## Disclaimer

It's my first gem ever. There are plenty of room for improvements there - feel free to contribute!

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'stability_ai'
```

And then execute:

```ruby
$ bundle install
```

Or install it yourself as:

```ruby
gem install stability_ai
```

## Configuration

Create an initializer in your Rails project or any Ruby application (e.g., `config/initializers/stability_ai.rb`) to configure your API keys and credentials:

```ruby
StabilityAI.configure do |config|
  config.stability_api_key = 'your_stability_api_key'
  config.path_prefix = './'
end
```

## Usage

Here's an example of how to use the gem with the Stability AI API:
Check [StabilityAI API](https://api.stability.ai/docs) for all the options available. If there are not passed in the `options` hash, the default value is used.

```ruby
require 'stability_ai'


client = StabilityAI::Client.new

# Text to image
text_to_image_response = client.text_to_image('engine_id', text_prompts: [{ text: 'A lighthouse on a cliff' }])
uri_image_1 = text_to_image_response.image_uris.first           # ->  <img src="#{uri_image_1}"/>  or image_tag(uri_image_1)
text_to_image_response.save_images('your_image_name_prefix')  # -> returns ["your_image_name_prefix_1.png", "your_image_name_prefix_2.png", ...]

# Image to image

options =     {
      text_prompts: [
        {
          text: "Snow",
        }
      ],
      image_strength: 0.35, # Default: 0.35 How much influence the init_image has on the diffusion process. Values close to 1 will yield images very similar to the init_image while values close to 0 will yield images wildly different than the init_image
      cfg_scale: 7, # DEFAULT: [0..35] How strictly the diffusion process adheres to the prompt text (higher values keep your image closer to your prompt),
      # clip_guidance_preset: "FAST_BLUE", # DEFAULT: NONE, WTF IS THAT?? FAST_BLUE FAST_GREEN NONE SIMPLE SLOW SLOWER SLOWEST
      # sampler: "DDIM",    # DEFAULT: Automatically choose by StableAI. DDIM DDPM K_DPMPP_2M K_DPMPP_2S_ANCESTRAL K_DPM_2 K_DPM_2_ANCESTRAL K_EULER K_EULER_ANCESTRAL K_HEUN K_LMS
      sytle_preset: "neon-punk", # check
    }
response = client.image_to_image(image_path: image_path, )

# Image to image upscale
response = client.image_to_image_upscale(engine_id: "esrgan-v1-x2plus", image_path: image_path, options: { width: 1024 })
response = client.image_to_image_upscale(image_path: image_path, use_maximum_resolution: true) # default engine: esrgan-v1-x2plus / use `use_maximum_resolution: true` is to use 2048px
response = client.image_to_image_upscale(image_binary: image_binary, )

# Image to image masking
# TODO
```

Replace `'engine_id'` with the appropriate engine ID for each method call.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mael-ha/stability_ai.

## License

The gem is available as open source under the terms of the MIT License.
