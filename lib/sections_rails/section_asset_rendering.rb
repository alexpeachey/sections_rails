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


      # Renders the assets of this section into the given out.
      def render_assets out
        render_js_assets out
        render_css_assets out
      end

      # Renders the CSS for this section.
      def render_css_assets out

        # Handle default case if no options given.
        return render_default_css_asset(out) unless @options.has_key? :css

        # Do nothing if 'css: nil' given.
        return unless @options[:css]

        render_custom_css_asset @options[:css], out
      end


      # Renders the CSS asset with the given filename.
      def render_custom_css_asset filename, out
        out << @view.stylesheet_link_tag(File.join(folder_includepath, @options[:css]))
      end


      # Renders the default CSS asset.
      def render_default_css_asset out
        css_includepath = find_css_includepath
        out << @view.stylesheet_link_tag(css_includepath) if css_includepath
      end


      # Renders the JS for this section.
      def render_js_assets out

        # Render default asset if no option given.
        return render_default_js_asset(out) unless @options.has_key? :js

        # Do nothing if 'js: nil' given.
        return unless @options[:js]

        render_custom_js_asset @options[:js], out
      end


      # Renders the default JS asset.
      def render_default_js_asset out
        js_includepath = find_js_includepath
        out << @view.javascript_include_tag(js_includepath) if js_includepath
      end


      # Renders the JS asset with the given filename.
      def render_custom_js_asset filename, out
        out << @view.javascript_include_tag(File.join(folder_includepath, filename))
      end

    end
  end
end
