require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module RailsReactUberEarts
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    config.api_only = true
  end
end
