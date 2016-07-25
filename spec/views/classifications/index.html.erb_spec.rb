require 'rails_helper'

RSpec.describe 'classifications/index' do
  context ( 'default view' ) {
    before {
      assign( :classifications, Classification.all )
    
      render
    }

    it {
      expect( rendered ).to have_css( 'h1', text: 'Classifications' )
    }
  }
end
