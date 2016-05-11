Classification API
==================

This API allows any third party to submit HTTP request/response data for a URL and retrieve our best guess of the availability of that URL.

Classifurlr uses many classification modules together in order to make a determination. Some modules can use machine learning and user feedback to improve.

This API (mostly) adheres to the JSON API 1.0 specification: http://jsonapi.org/

Query for classification
------------------------

Send POST requests to /classify to let us know that you would like a classification of a URL transaction. Send as much data as you have (including historic data) because each classification module will use what it can.

POSTs to /classify should have the Content-Type application/vnd.api+json.

As per JSON API 1.0, the type attribute is required and must be the string 'classifications'.

### Example

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/x-www-form-urlencoded
    Accept: application/vnd.api+json
    
    {
      "data": {
        "type": "classifications",
        "attributes": {
          "url": "http://cyber.law.harvard.edu",
          "countryCode": "CN",
          "responses": [ {
            "statusCode": 200,
            "rawResults": "<!DOCTYPE html><html><head><title>Berkman Center for Internet and society</title></head><body>...</body></html>",
            "timing": "483 ms",
            "errorsEncountered": "",
            "certificateChain": "",
            "screenshot": "data:image/png;base64,iVBOR...==",
            "request": {
              "url": "http://cyber.law.harvard.edu",
              "maxAge": 300,
              "timeout": 10,
              "requestHeaders": "Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0"

            }
          } ]
        }
      }
    }

#### HTTP response

    HTTP/1.1 200 OK
    Content-Type: application/vnd.api+json

    {
      "data": {
        "type": "classifications",
        "id": "1134",
        "attributes": {
          "probability": 1.0,
          "available": true,
          "blocked": false,
          "throttled": false,
          "classifiers": [ {
            "name": "status_code_classifier",
            "probability": 1.0,
            "available": true,
            "blocked": false,
            "throttled": false,
            "weight": 1.0
          } ]
        }
      }
    }

