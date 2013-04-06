require File.expand_path('../boot', __FILE__)

require "action_controller/railtie"
require "action_view/railtie"
require "sprockets/railtie"
# require 'rails/all'
require 'haml'

Bundler.require(*Rails.groups(:assets => %w(development test)))
# require 'sections_rails'

module Dummy
  class Application < Rails::Application
    config.encoding = "utf-8"
    config.assets.enabled = true
    config.assets.version = '1.0'
  end
end

