require "spec_helper"

describe SectionsRails::PartialParser do

  describe '#find_sections' do
    it 'finds ERB sections with symbols' do
      expect(SectionsRails::PartialParser.find_sections("one <%= section :alpha %> two")).to eq ['alpha']
    end

    it 'finds ERB sections with single quotes' do
      expect(SectionsRails::PartialParser.find_sections("one <%= section 'alpha' %> two")).to eq ['alpha']
    end

    it 'finds ERB sections with double quotes' do
      expect(SectionsRails::PartialParser.find_sections('one <%= section "alpha" %> two')).to eq ['alpha']
    end

    it 'finds ERB sections with parameters' do
      expect(SectionsRails::PartialParser.find_sections('one <%= section "alpha", css: false %> two')).to eq ['alpha']
    end

    it 'finds HAML sections with symbols' do
      expect(SectionsRails::PartialParser.find_sections("= section :alpha")).to eq ['alpha']
    end

    it 'finds HAML sections with single quotes' do
      expect(SectionsRails::PartialParser.find_sections("= section 'alpha'")).to eq ['alpha']
    end

    it 'finds HAML sections with double quotes' do
      expect(SectionsRails::PartialParser.find_sections('= section "alpha"')).to eq ['alpha']
    end

    it 'finds indented HAML sections' do
      expect(SectionsRails::PartialParser.find_sections('    = section :alpha')).to eq ['alpha']
    end

    it 'finds HAML sections after a tag' do
      expect(SectionsRails::PartialParser.find_sections('li= section :alpha')).to eq ['alpha']
    end

    it 'finds HAML sections with parameters' do
      expect(SectionsRails::PartialParser.find_sections('= section "alpha", css: false')).to eq ['alpha']
    end

    it 'finds all results in the text' do
      expect(SectionsRails::PartialParser.find_sections("one <%= section 'alpha' \ntwo <%= section 'beta'")).to eq ['alpha', 'beta']
    end

    it 'sorts the results' do
      expect(SectionsRails::PartialParser.find_sections("one <%= section 'beta' \ntwo <%= section 'alpha'")).to eq ['alpha', 'beta']
    end

    it 'removes duplicates' do
      expect(SectionsRails::PartialParser.find_sections("one <%= section 'alpha' \ntwo <%= section 'alpha'")).to eq ['alpha']
    end
  end
end

