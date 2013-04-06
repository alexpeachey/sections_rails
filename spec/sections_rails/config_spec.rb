require "spec_helper"

describe SectionsRails::Config do

  it 'is provided as a Singleton instance' do
    expect(SectionsRails.config).to_not be_nil
  end

  describe 'initialize' do

    describe 'options' do
      it 'uses reasonable default values' do
        config = SectionsRails::Config.new
        expect(config.path).to eql 'app/sections'
        expect(config.js_extensions).to include 'js'
        expect(config.js_extensions).to include 'js.coffee'
        expect(config.js_extensions).to include 'coffee'
      end

      it 'allows to provide custom configuration values' do
        config = SectionsRails::Config.new path: 'custom path'
        expect(config.path).to eql 'custom path'
      end

      it 'raises an ArgumentError if an unknown configuration option is provided' do
        expect { config = SectionsRails::Config.new zonk: 'foo'}.to raise_error ArgumentError, "Invalid option 'zonk' for SectionsRails::Config"
      end
    end
  end
end

