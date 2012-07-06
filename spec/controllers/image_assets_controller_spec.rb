require 'spec_helper'

describe ImageAssetsController do
  render_views

  before :each do
    RSpec::Matchers.define :have_image_tag do |tag_name|
      match do |body|
        body =~ Regexp.new("<img.*src=\"#{tag_name}\"")
      end
    end
  end

  after :each do
    response.should be_success
  end

  it 'supports GIF images' do
    get :gif
    response.body.should have_image_tag '/assets/image_assets/foo.gif'
  end

  it 'supports JPG images' do
    get :jpg
    response.body.should have_image_tag '/assets/image_assets/foo.jpg'
  end

  it 'supports JPEG images' do
    get :jpeg
    response.body.should have_image_tag '/assets/image_assets/foo.jpeg'
  end

  it 'supports PNG images' do
    get :png
    response.body.should have_image_tag '/assets/image_assets/foo.png'
  end
end

