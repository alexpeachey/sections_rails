require 'spec_helper'

describe ViewTypesController do
  render_views

  describe 'supported view types' do
    after :each do
      expect(response).to be_success
    end

    it 'allows to use the section helper in ERB views' do
      get :erb
      expect(response.body.strip).to eql 'Foo partial content'
    end

    it 'allows to use the section helper in HAML views' do
      get :haml
      expect(response.body.strip).to eql 'Foo partial content'
    end
  end
end

