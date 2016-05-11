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
              "timeout": 10,
              "requestHeaders": "Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0",
              "asn": "23650"

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
          "status": "up",
          "available": 1.0,
          "blocked": 0.0,
          "throttled": 0.0,
          "classifiers": [ {
            "name": "status_code_classifier",
            "available": 1.0,
            "weight": 1.0
          }, {
            "name": "block_page_classifier",
            "available": 1.0,
            "blocked": 0.0,
            "weight": 1.0
          }, {
            "name": "timing_classifier",
            "throttled": 0.0,
            "weight": 0.5
          } ]
        }
      }
    }

### classification request attributes

**url**

The URL to which the given request and response data applies.

**countryCode**

The ISO2 code for the country from which you are interested if the URL is available. The country must have some relation to the request/response data submitted. For example, if you submit data pertaining to a request from China, the classifiers will not be able to answer if the URL is available from Ireland.

However, if the responses array contains data on many requests from different ASNs in Ireland, the classifiers may be able to generalize availability in Ireland, e.g., if the URL is not available on one of many ASNs in Ireland, there is a high but not perfect probability that the URL is be available from any one location within the country.

This attribute is not required and, if omitted, the classifiers will report on the raw request/response data as if you asked if the URL was available from the specific ASN of the request of the first response in the responses array.

**responses**

An array of response data returned to the original request. There must be at least one but historic data can also be sent and may be useful to some classifiers.

**responses[x].request**

Data about the original request related to the response data.

#### response attributes

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

#### request attributes

**timeout**

The time, in seconds, after which the request will be canceled by the original machine.

**requestHeaders**

The HTTP headers sent as part of the original request. Each header should be separated by CRLF as defined by HTTP.

**asn**

The Autonomous System Number for the ISP to which the original requesting machine is connected.

### classification response attributes

**status**

The status of the request/response data as determined by the classifications. The status attribute is a simplified way to examine a classification as it is just a string and will be one of the following: up, down, blocked, undetermined.

**available**

The probability, represented as a number from 0 to 1, that the given page is available to users in the given country as determined by weighting the results from individual classifiers.

**blocked**

The probability, represented as a number from 0 to 1, that the given page is being blocked by some entity on the network as determined by weighting the results from individual classifiers.


Provide feedback for a classification
-------------------------------------

**id**

The ID of the classification. Can be used to provide feedback after further analysis or human interpretation.



