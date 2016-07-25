require 'rails_helper'

RSpec.describe ClassificationsController do
  describe ( 'get index' ) {
    it {
      get :index
      expect( response.code ).to eq( '200' )
    }
  }
end
