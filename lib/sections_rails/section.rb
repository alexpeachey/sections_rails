module SectionsRails
  require "sections_rails/config"

  class Section

    def initialize section_name, view = nil, options = {}
      @section_name = section_name.to_s
      @options = options

      # This is necessary for running view helper methods.
      @view = view
    end

    # Returns the names of any subdirectories that the section is in.
    # Example: the section named 'folder1/folder2/section' has the directory_name 'folder1/folder2'.
    def directory_name
      @directory_name ||= File.dirname(@section_name).gsub(/^\.$/, '')
    end

    # Returns the file name of the section.
    # Example 'section'
    def filename
      @filename ||= File.basename @section_name, '.*'
    end

    # Path to the folder for asset includes.
    # Example: 'folder/section'
    def folder_includepath
      @folder_includepath ||= File.join directory_name, filename
    end

    # Path of the folder on the file system.
    # Example: 'app/sections/folder/section'
    def folder_filepath
      @folder_filepath ||= File.join SectionsRails.config.path, directory_name, filename
    end

    # Path to access assets on the file system.
    # Includes only the base name of assets, without extensions.
    # Example: 'app/sections/folder/section/section'
    def asset_filepath
      @asset_filepath ||= File.join SectionsRails.config.path, asset_includepath
    end

    # Path for including assets into the web page.
    #
    def asset_includepath
      @asset_includepath ||= File.join(directory_name, filename, filename).gsub(/^\//, '')
    end

    # The path for accessing the partial on the filesystem.
    # Example: '
    def partial_filepath
      @partial_filepath ||= File.join(SectionsRails.config.path, directory_name,filename, "_#{filename}").gsub(/^\//, '')
    end

    # For including the partial into views.
    def partial_includepath
      @partial_includepath ||= File.join(directory_name, filename, "#{filename}").gsub(/^\//, '')
    end

    # Returns the asset path of asset with the given extensions.
    # Helper method.
    def find_asset_includepath asset_option, extensions
      return nil if asset_option == false
      return asset_option if asset_option
      extensions.each do |ext|
        file_path = "#{asset_filepath}.#{ext}"
        return asset_includepath if File.exists? file_path
      end
      nil
    end

    # Returns the path to the JS asset of this section, or nil if the section doesn't have one.
    def find_css_includepath
      @find_css_includepath ||= find_asset_includepath @options[:css], SectionsRails.config.css_extensions
    end

    # Returns the path to the JS asset of this section, or nil if the section doesn't have one.
    def find_js_includepath
      @find_js_includepath ||= find_asset_includepath @options[:js], SectionsRails.config.js_extensions
    end

    # Returns the filename of the partial of this section, or nil if this section has no partial.
    def find_partial_filepath
      SectionsRails.config.partial_extensions.each do |ext|
        path = "#{partial_filepath}.#{ext}"
        return path if File.exists? path
      end
      nil
    end

    # Returns a list of all section names in the given text.
    #
    # @param [ String ] text
    # @return [ Array<String> ]
    def self.find_sections text

      # Find sections in ERB templates.
      result = text.scan(/<%=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      # Find sections in HAML templates.
      result.concat text.scan(/^\s*\=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq

      result
    end

    # TODO: replace this with find_asset.
    def has_asset? *extensions
      extensions.flatten.each do |ext|
        return true if File.exists?("#{asset_filepath}.#{ext}")
      end
      false
    end

    # TODO: replace this with find_asset.
    def has_default_js_asset?
      has_asset? SectionsRails.config.js_extensions
    end

    # TODO: replace this with find_asset.
    def has_default_style_asset?
      has_asset? SectionsRails.config.css_extensions
    end

    # Returns whether this section has a template.
    # Deprecated.
    def has_partial?
      @view.lookup_context.template_exists? partial_includepath
    end

    def render
      result = []

      # Check if section exists.
      raise "Section #{folder_filepath} doesn't exist." unless Dir.exists? folder_filepath

      # Include assets only for development mode.
      if Rails.env != 'production'

        # Include JS assets.
        if @options.has_key? :js
          if @options[:js]
            result << @view.javascript_include_tag(File.join(folder_includepath, @options[:js]))
          else
            # :js => (false|nil) given --> don't include any JS.
          end
        else
          # No :js configuration option given --> include the default script.
          js_includepath = find_js_includepath
          result << @view.javascript_include_tag(js_includepath) if js_includepath
        end

        # Include CSS assets.
        if @options.has_key? :css
          if @options[:css]
            # Custom filename for :css given --> include the given CSS file.
            result << @view.stylesheet_link_tag(File.join(folder_includepath, @options[:css]))
          else
            # ":css => false" given --> don't include any CSS.
          end
        else
          # No option for :css given --> include the default stylesheet.
          css_includepath = find_css_includepath
          result << @view.stylesheet_link_tag(css_includepath) if css_includepath
        end
      end

      # Render the section partial into the view.
      case @options[:partial]
        when :tag
          result << @view.content_tag(:div, '', :class => filename)

        when false
          # partial: false given --> render nothing

        when nil
          # partial: nil given --> render default partial
          partial_filepath = find_partial_filepath
          if partial_filepath
            result << @view.render(:partial => partial_includepath, :locals => @options[:locals])
          else
            result << @view.content_tag(:div, '', :class => filename)
          end

        else
          # partial: custom path given --> render custom partial
          result << @view.render("#{path}/#{partial}", @options[:locals])
      end

      result.join("\n").html_safe
    end
  end
end
