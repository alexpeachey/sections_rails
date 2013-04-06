module SectionsRails
  require "sections_rails/config"
  require 'sections_rails/partial_parser'
  require 'sections_rails/section_asset_rendering'
  require 'sections_rails/section_partial_rendering'


  # Provides intelligent support for dealing with sections.
  class Section
    include SectionAssetRenderering
    include SectionPartialRendering

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

    # Path of the folder on the file system.
    # Example: 'app/sections/folder/section'
    def folder_filepath
      @folder_filepath ||= File.join SectionsRails.config.path, directory_name, filename
    end

    # Returns the sections that this section references.
    # If 'recursive = true' is given, searches recursively for sections referenced by the referenced sections.
    # Otherwise, simply returns the sections that are referenced by this section.
    def referenced_sections recursive = true
      result = PartialParser.find_sections partial_content

      # Find all sections within the already known sections.
      if recursive
        i = -1
        while (i += 1) < result.size
          Section.new(result[i]).referenced_sections(false).each do |referenced_section|
            result << referenced_section unless result.include? referenced_section
          end
        end
      end
      result.sort!
    end


    # Renders this section, i.e. returns the HTML for this section.
    def render &block
      result = []

      # Check if section exists.
      raise "Section #{folder_filepath} doesn't exist." unless Dir.exists? folder_filepath

      # Include assets only for development mode.
      if Rails.env != 'production'
        render_assets result
      end

      render_partial result, &block

      result.join("\n").html_safe
    end
  end
end
