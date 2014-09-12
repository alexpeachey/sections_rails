unless ENV['COVERALLS_CONFIG'] == 'nocoveralls'
  require 'coveralls'
  Coveralls.wear!
end
ENV["RAILS_ENV"] ||= 'test'

require File.expand_path("../dummy/config/environment.rb",  __FILE__)
require 'rspec/rails'
require 'sections_rails'


RSpec.configure do |config|
  config.infer_base_class_for_anonymous_controllers = false
  config.mock_with :rspec
  config.infer_spec_type_from_file_location!
end
