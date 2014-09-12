require 'spec_helper'

describe StyleAssetsController do
  render_views

  before :each do
    RSpec::Matchers.define :have_style_tag do |tag_name|
      match do |body|
        body =~ Regexp.new("<link href=\"#{tag_name}")
      end
    end
  end

  after :each do
    expect(response).to be_success
  end

  describe 'supported style languages' do
    it 'CSS assets' do
      get :css
      expect(response.body).to have_style_tag '/assets/style_assets/css/css.css'
    end

    it 'SASS assets' do
      get :sass
      expect(response.body).to have_style_tag '/assets/style_assets/sass/sass.css'
    end

    it 'CSS.SASS assets' do
      get :css_sass
      expect(response.body).to have_style_tag '/assets/style_assets/css_sass/css_sass.css'
    end

    it 'SCSS assets' do
      get :scss
      expect(response.body).to have_style_tag '/assets/style_assets/scss/scss.css'
    end

    it 'CSS.SCSS assets' do
      get :css_scss
      expect(response.body).to have_style_tag '/assets/style_assets/css_scss/css_scss.css'
    end
  end

  context 'setting a custom style filename' do
    before :each do
      get :custom_style
    end

    it 'includes the given style file into the page' do
      expect(response.body).to have_style_tag '/assets/style_assets/custom_style/different_name.css'
    end

    it "doesn't include the default script file into the page" do
      expect(response.body).to_not have_style_tag '/assets/style_assets/custom_style/custom_style.css'
    end
  end

  context 'setting the script configuration option to false' do
    it "doesn't include any script tag into the page" do
      get :no_style
      expect(response.body).to_not have_style_tag '/assets/style_assets/no_style/no_style.css'
    end
  end

  context 'production_mode' do

    before :each do
      Rails.env = "production"
      Rails.application.config.assets.compile = false
    end

    after :each do
      Rails.env = "test"
      Rails.application.config.assets.compile = true
    end

    it "doesn't render style assets" do
      get :production_mode
      expect(response.body).to_not have_style_tag '/assets/style_assets/production_mode/production_mode.css'
    end
  end
end

