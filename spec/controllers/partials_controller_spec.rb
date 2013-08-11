require 'spec_helper'

describe PartialsController do
  render_views

  describe 'supported partial types' do
    after :each do
      expect(response).to be_success
    end

    it 'allows to use ERB partials' do
      get :erb_section
      expect(response.body.strip).to eql 'ERB partial content'
    end

    it 'allows to use HAML partials' do
      get :haml_section
      expect(response.body.strip).to eql 'HAML partial content'
    end
  end

  context 'no partial options given' do
    it 'renders the default partial' do
      get :no_options
      expect(response.body.strip).to eql 'default partial content'
    end
  end

  context 'partial with tag option given' do
    it 'renders an empty tag even though the section contains a partial' do
      get :tag_option
      expect(response.body.strip).to eql '<div class="tag_option"></div>'
    end
  end

  describe 'providing a custom partial name' do
    before :each do
      get :custom_partial
    end

    it 'renders the given partial' do
      expect(response.body).to include 'custom partial content'
    end

    it "doesn't render the default partial" do
      expect(response.body).to_not include 'default partial content'
    end
  end

  describe 'disabling partials for a section' do
    before :each do
      get :disabled
    end

    it "doesn't render the partial tag" do
      expect(response.body.strip).to_not include '<div class="disabled">'
    end

    it "doesn't render the partial" do
      expect(response.body.strip).to_not include 'disabled partial content'
    end
  end

  describe 'production mode' do

    before :each do
      Rails.env = 'production'
    end

    after :each do
      Rails.env = 'test'
    end

    it 'renders partials normally' do
      get :production_mode
      expect(response.body.strip).to include 'partial content'
    end
  end

  describe 'partial with block' do
    it 'renders the block inside the partial' do
      get :partial_with_block
      expect(response.body.strip).to match /partial line 1.\n+block content.\n+partial line 2./
    end
  end

  describe 'partial with custom partial name and block' do
    it 'renders the block inside the custom partial' do
      get :custom_partial_with_block
      expect(response.body.strip).to match /custom partial line 1.\n+\s*block content\n+custom partial line 2./
    end
  end
end


