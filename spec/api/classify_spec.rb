require 'rails_helper'

RSpec.describe 'classify' do
  let ( :transaction_data ) {
    {
      type: 'transactions',
      attributes: {
        url: 'http://cyber.law.harvard.edu',
        responses: [ {
          statusCode: 200,
          responseHeaders: "Cache-Control: public, max-age=3600\r\nContent-Type: text/html; charset=utf-8",
          rawResults: '<!DOCTYPE html><html><head><title>Berkman Center for Internet and society</title></head><body>...</body></html>',
          request: {
            url: 'http://cyber.law.harvard.edu',
            timeout: 10,
            requestHeaders: "Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0",
            asn: '23650'
          }
        } ]
      }
    }
  }

  it ( 'accepts requests to classify' ) {
    post '/classify', format: :json, data: transaction_data
    expect( response.status ).to eq( 201 )
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

  it ( 'responds with JSON-API' ) {
    post '/classify', format: :json, data: transaction_data

    parsed = JSON.parse response.body

    expect( parsed[ 'data' ] ).not_to be_nil
  }

  it ( 'classifies up transactions as up' ) {
    post '/classify', format: :json, data: transaction_data

    parsed = JSON.parse response.body

    expect( parsed[ 'data' ][ 'attributes' ][ 'status' ] ).to eq( 'up' )
  }


end

