require 'rails_helper'

RSpec.describe 'classify' do
  let ( :transaction_data ) {
    {
      type: 'transactions',
      attributes: {
        url: 'http://cyber.law.harvard.edu',
        responses: [ {
          statusCode: 200,
          rawResults: '<!DOCTYPE html><html><head><title>Berkman Center for Internet and society</title></head><body>...</body></html>',
          request: {
            timeout: 10,
            requestHeaders: 'Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0',
            asn: '23650'
          }
        } ]
      }
    }
  }

  it ( 'accepts requests to classify' ) {
    post '/classify', format: :json, data: transaction_data
    expect( response.status ).to eq( 201 )

    #puts "response: #{response.body}"

    #classification = Classification.last

    #puts "classification: #{classification.as_json}"

    #expect( response.body ).to eq( { id: 6 }.as_json )

    #expect( response.body ).to eq( { data: { type: 'classifications' } }.as_json )
  }

  it ( 'creates a classification' ) {
    expect {
      post '/classify', format: :json, data: transaction_data
    }.to change { Classification.count }.by( 1 )

  }


  it ( 'accepts response data' ) {
    post '/classify', format: :json, data: transaction_data

    expect( response.status ).to eq( 201 )
  }

  it ( 'classifies up transactions as up' ) {
    post '/classify', format: :json, data: transaction_data

    #puts response.body

    parsed = JSON.parse response.body

    expect( parsed[ 'status' ] ).to eq( 'up' )
  }


end

