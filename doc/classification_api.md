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
            "timing": "483ms",
            "errorsEncountered": "",
            "certificateChain": "",
            "screenshot": "data:image/png;base64,iVBOR...==",
            "request": {
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

### classification attributes

**url**

The URL to which the given request and response data applies.

**countryCode**

The ISO2 code for the country whence the request originated. This metadata may be useful to some classifiers, for example, comparing to known block pages or block page IPs.

**responses**

An array of response data returned to the original request. There must be at least one but historic data can also be sent and may be useful to some classifiers.

**responses[x].request**

Data about the original request related to the response data.

### response attributes

**statusCode**

HTTP status code returned in the response.

**rawResults**

Full HTML of response.

**timing**

Time it took for the reponse to return data to the machine issuing the original request.

**errorsEncountered**

Any errors encountered during the request, separated by CRLF.

**certificateChain**

Certificates accepted during the request. If there are more than one certificate, separate them with an empty line (CRLF).

**screenshot**

Data URI of an image of the rendered response, if available.

**request**

Data about the request original request to which this data is a response.

### request attributes


