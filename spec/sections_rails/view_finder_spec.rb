require "spec_helper"
require 'sections_rails/view_finder'


describe "SectionsRails::ViewFinder" do

  describe '#find_all_views' do
    let(:result) { SectionsRails::ViewFinder.find_all_views 'spec/sections_rails/view_finder_spec' }
    let(:empty_result) { SectionsRails::ViewFinder.find_all_views 'spec/sections_rails/view_finder_spec/empty' }

    it 'returns all erb views' do
      expect(result).to include 'spec/sections_rails/view_finder_spec/erb/_erb.html.erb'
    end

    it 'returns all haml views' do
      expect(result).to include 'spec/sections_rails/view_finder_spec/haml/_haml.html.haml'
    end

    it 'returns all ruby files' do
      expect(result).to include 'spec/sections_rails/view_finder_spec/rb/decorator.rb'
    end

    it 'does not return js files' do
      expect(result).not_to include 'spec/sections_rails/view_finder_spec/assets/javascript.js'
    end

    it 'does not return css files' do
      expect(result).not_to include 'spec/sections_rails/view_finder_spec/assets/stylesheet.css'
    end

    it 'returns views that are deeper nested in the directory structure' do
      expect(result).to include 'spec/sections_rails/view_finder_spec/nested/deeper/nested.html.erb'
    end

    it 'returns an empty array if there are no views' do
      expect(empty_result).to eq []
    end
  end
end

