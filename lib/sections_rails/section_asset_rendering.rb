module SectionsRails

  # Helps with rendering the assets of a section.
  module SectionAssetRenderering
    extend ActiveSupport::Concern

    included do

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


      # Returns the path to the JS asset of this section, or nil if the section doesn't have one.
      def find_js_includepath
        @find_js_includepath ||= find_asset_includepath @options[:js], SectionsRails.config.js_extensions
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


      # Path to the folder for asset includes.
      # Example: 'folder/section'
      def folder_includepath
        @folder_includepath ||= File.join directory_name, filename
      end


      # Renders the assets of this section into the given result.
      def render_assets result
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
    end
  end
end
