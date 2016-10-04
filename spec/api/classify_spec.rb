require 'rails_helper'

RSpec.describe 'classify' do
  let ( :har_data ) {
    {
      "log": {
        "version": "1.2",
        "pages": [
          {
            "startedDateTime": "2016-08-10T18:46:56.902Z",
            "id": "page_1",
            "title": "http://cyber.law.harvard.edu/"
          }
        ],
        "entries": [ {
          "pageref": "page_1",
          "startedDateTime": "2016-08-10T18:46:56.902Z",
          "time": 62.799999956041574,
          "request": {
            "_asn": "23650",
            "method": "GET",
            "url": "http://cyber.law.harvard.edu/",
            "httpVersion": "HTTP/1.1",
            "headers": [ {
              "name": "Accept",
              "value": "text/html"
            }, {
              "name": "Accept-Language",
              "value": "zh-Hans,zh"
            }, {
              "name": "User-Agent",
              "value": "Mozilla/5.0 AppleWebKit/537 Chrome/41.0"
            } ],
            "cookies": [],
            "headersSize": 103,
            "bodySize": 0
          },
          "response": {
            "status": 200,
            "statusText": "OK",
            "httpVersion": "HTTP/1.1",
            "headers": [ {
              "name": "Cache-Control",
              "value": "public, max-age=3600"
            }, {
              "name": "Content-Type",
              "value": "text/html; charset=UTF-8"
            } ],
            "cookies": [],
            "content": {
              "size": 37120,
              "mimeType": "text/html",
              "_raw": "<!DOCTYPE html><html><head><title>Berkman Klein Center for Internet and society</title></head><body>...</body></html>",
              "_screenshot": "data:image/png;base64,iVBOR...=="
            },
            "headersSize": 77,
            "bodySize": 8548,
            "_errors": []
          },
          "cache": {},
          "timings": {
            "connect": 15.0040000444278,
            "send": 0.09600003249940059,
            "wait": 16.833000001497602,
            "receive": 1.789000001735996
          },
          "serverIPAddress": "128.103.64.74",
          "_certificates": []
        } ]
      }
    }
  }

  it ( 'accepts requests to classify' ) {
    post '/classify', format: :json, log: har_data[ :log ]
    expect( response.status ).to eq( 201 )
  }

  it ( 'creates a classification' ) {
    expect {
      post '/classify', format: :json, log: har_data[ :log ]
    }.to change { Classification.count }.by( 1 )

  }

  it ( 'responds with JSON-API' ) {
    post '/classify', format: :json, log: har_data[ :log ]

    parsed = JSON.parse response.body

    expect( parsed[ 'data' ] ).not_to be_nil
  }

  it ( 'classifies up transactions as up' ) {
    post '/classify', format: :json, log: har_data[ :log ]

    parsed = JSON.parse response.body

    expect( parsed[ 'data' ][ 'attributes' ][ 'status' ] ).to eq( 'up' )
  }
end

