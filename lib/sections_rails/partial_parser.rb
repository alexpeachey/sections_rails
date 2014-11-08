module SectionsRails
  module PartialParser

    # Returns a list of all section names in the given text.
    #
    # @param [ String ] text
    # @return [ Array<String> ]
    def self.find_sections text
      return [] if text.blank?
      text.scan(/=\s*section\s+['":]([^'",\s]+)/).flatten.sort.uniq
    end
  end
end

