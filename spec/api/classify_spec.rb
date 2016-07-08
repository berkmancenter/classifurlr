require 'rails_helper'

RSpec.describe 'classify' do
  it ( 'classifies transactrions' ) {
    post '/classify', format: :json
    expect( response.status ).to eq( 201 )

    #expect( last_response.body ).to eq( { data: { type: 'classifications' } }.to_json )
  }
end

