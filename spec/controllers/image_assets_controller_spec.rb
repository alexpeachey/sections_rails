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
    expect(response).to be_success
  end

  it 'supports GIF images' do
    get :gif
    expect(response.body).to have_image_tag '/assets/image_assets/foo.gif'
  end

  it 'supports JPG images' do
    get :jpg
    expect(response.body).to have_image_tag '/assets/image_assets/foo.jpg'
  end

  it 'supports JPEG images' do
    get :jpeg
    expect(response.body).to have_image_tag '/assets/image_assets/foo.jpeg'
  end

  it 'supports PNG images' do
    get :png
    expect(response.body).to have_image_tag '/assets/image_assets/foo.png'
  end
end

