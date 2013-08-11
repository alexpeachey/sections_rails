module SectionsRails

  # Helps with rendering partials of sections.
  module SectionPartialRendering
    extend ActiveSupport::Concern

    included do

      # The path for accessing the partial on the filesystem.
      # Example: '
      def partial_renderpath partial_filename = nil
        File.join(directory_name, filename, partial_filename || filename).gsub(/^\//, '')
      end

      # The path for accessing the partial on the filesystem.
      # Example: '
      def partial_filepath partial_filename = nil
        File.join(SectionsRails.config.path, directory_name, filename, "_#{partial_filename or filename}").gsub(/^\//, '')
      end

      # For including the partial into views.
      def partial_includepath
        @partial_includepath ||= File.join(directory_name, filename, "#{filename}").gsub(/^\//, '')
      end

      # Returns the content of this sections partial.
      def partial_content
        return @partial_content if @has_partial_content
        @has_partial_content = true
        if (partial_path = find_partial_filepath)
          @partial_content = IO.read partial_path
        end
      end

      # Returns the filename of the partial of this section, or nil if this section has no partial.
      # Uses the given custom partial name, or the default partial name if none is given.
      def find_partial_filepath partial_filename = nil
        SectionsRails.config.partial_extensions.each do |ext|
          path = "#{partial_filepath(filename)}.#{ext}"
          return path if File.exists? path
        end
        nil
      end

      # Returns the path of the partial of this section for rendering, or nil if this section has no partial.
      # Uses the given custom partial name, or the default partial name if none is given.
      def find_partial_renderpath partial_filename = nil
        SectionsRails.config.partial_extensions.each do |ext|
          return partial_renderpath(partial_filename) if File.exists? "#{partial_filepath(filename)}.#{ext}"
        end
        nil
      end


      # Renders the section partial into the view.
      def render_partial result, &block
        if @options.has_key? :partial
          if @options[:partial] == :tag
            # :partial => :tag given
            render_empty_tag result
          elsif @options[:partial]
            # Custom partial name given
            render_custom_partial  result, &block
          else
            # :partial => (false|nil) given --> render nothing.
          end
        else
          # No :partial option given
          render_default_partial result, &block
        end
      end

      def render_custom_partial result, &block
        if block_given?
          result << @view.render({:layout => find_partial_renderpath(@options[:partial])}, @options[:locals], &block)
        else
          result << @view.render(find_partial_renderpath(@options[:partial]), @options[:locals])
        end
      end

      def render_default_partial result, &block
        partial_filepath = find_partial_filepath
        if partial_filepath

          if block_given?
            result << @view.render(:layout => partial_includepath, :locals => @options[:locals], &block)
          else
            result << @view.render(:partial => partial_includepath, :locals => @options[:locals])
          end
        else
          result << @view.content_tag(:div, '', :class => filename)
        end
      end

      def render_empty_tag result
        result << @view.content_tag(:div, '', :class => filename)
      end
    end
  end
end
