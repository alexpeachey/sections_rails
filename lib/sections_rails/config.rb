# Configuration options for SectionsRails.
# Set in an initializer file in /config/initializers/.
#
# Example:
# SectionsRails.configure do |config|
#   config.spec_dir  = "spec/javascripts"
#   config.driver    = :webkit
# end if defined?(Konacha)
module SectionsRails

  class << self
    def config
      @config ||= Config.new
    end
  end

  class Config
    attr_accessor :path, :js_extensions, :css_extensions, :partial_extensions

    def initialize options = {}
      options.reverse_merge!({ path: 'app/sections',
                               js_extensions: %w(js js.coffee coffee),
                               css_extensions: %w(css css.scss css.sass sass scss),
                               partial_extensions: %w(html.erb html.haml html.slim) })

      options.each do |option, value|
        if self.respond_to? option
          send("#{option}=", value)
        else
          raise ArgumentError.new "Invalid option '#{option}' for #{self.class.name}"
        end
      end
    end
  end
end
