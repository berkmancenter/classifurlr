Classification API
==================

This API allows any third party to submit HTTP transaction data (request/response data) for a URL and retrieve our best guess of the availability of that URL.

Classifurlr uses many classification modules together in order to make a determination. Some modules can use machine learning and user feedback to improve.

This API (mostly) adheres to the JSON API 1.0 specification: http://jsonapi.org/

Query for classification
------------------------

Send POST requests to /classify to let us know that you would like a classification of one or more transaction with a URL. Send as much data as you have (including historic data) because each classification module will use what it can.

POSTs to /classify should have the Content-Type: application/json.

As per JSON API 1.0, the type attribute is required and must be the string 'transactions'.

### Basic Example

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/json
    Accept: application/json
    
    {
      "data": {
        "type": "transactions",
        "attributes": {
          "url": "http://cyber.law.harvard.edu",
          "responses": [ {
            "statusCode": 200,
            "responseHeaders": "Cache-Control: public, max-age=3600\r\nContent-Type: text/html; charset=utf-8",
            "rawResults": "<!DOCTYPE html><html><head><title>Berkman Center for Internet and society</title></head><body>...</body></html>",
            "timings": {
               "blocked": 0,
               "dns": -1,
               "connect": 15,
               "send": 20,
               "wait": 38,
               "receive": 12,
               "ssl": -1,
               "comment": ""
            },
            "errorsEncountered": "",
            "certificateChain": "",
            "screenshot": "data:image/png;base64,iVBOR...==",
            "request": {
              "url": "http://cyber.law.harvard.edu",
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
    Content-Type: application/json

    {
      "data": {
        "type": "classifications",
        "id": "1134",
        "attributes": {
          "status": "up",
          "available": 1.0,
          "blockPage": 0.0,
          "classifiers": [ {
            "name": "status_code_classifier",
            "available": 1.0,
            "weight": 0.6
          }, {
            "name": "block_page_classifier",
            "available": 1.0,
            "blockPage": 0.0,
            "weight": 1.0
          } ]
        }
      }
    }

### classification request attributes

**url**

The URL to which the given request and response data applies. The url attribute is required.

**responses**

An array of response data returned to the original request. There must be at least one response to classify or an error will be returned.

Historic data can be sent and may be useful to some classifiers.

Multiple responses from a single session can also be sent and will allow classifiers to follow redirects.

#### response attributes

**statusCode**

HTTP status code returned in the response.

**responseHeaders**

The HTTP headers sent as part of the response. Each header should be separated by CRLF as defined by HTTP.

If you are sending more than one response with your transaction data, it is strongly recommended that you include the responseHeaders attribute in each response object (as well as matching url in the related request object). This way, the classifiers can differentiate between, e.g., redirects, historic data, or unrelated requests.

**rawResults**

Full HTML of response.

**timings**

This object describes various phases within request-response round trip. All times are specified in milliseconds.

Please follow the timings format in the HAR spec: http://www.softwareishard.com/blog/har-12-spec/#timings

Possible attributes for the timings object include:

* blocked
* dns
* connect
* send
* wait
* receive
* ssl
* comment

**errorsEncountered**

Any errors encountered during the request, separated by CRLF.

**certificateChain**

Certificates accepted during the request. If there are more than one certificate, separate them with an empty line (CRLF).

**screenshot**

Data URI of an image of the rendered response, if available.

**request**

Data about the request original request to which this data is a response.

#### response[x].request attributes

**url**

For each request, you can include the url requested. This is useful to classifiers to determine/follow redirects and other anomalies.

If you are sending more than one response, it is strongly recommended that you include the url attribute in each request object (as well as matching responseHeaders in the related response object). This way, the classifiers can differentiate between, e.g., redirects, historic data, or unrelated requests.

If the url attribute is **not** supplied in the request objects, the classifiers will be forced to operate on the first response/request pair only which may give you a less accurate classification.

**timeout**

The time, in seconds, after which the request will be canceled by the original machine.

**requestHeaders**

The HTTP headers sent as part of the original request. Each header should be separated by CRLF as defined by HTTP.

**asn**

The Autonomous System Number for the ISP to which the original requesting machine is connected.

### classification response attributes

**id**

The ID of the classification. Set by Classifurlr, it can be used to provide feedback after further analysis or human interpretation.

**status**

The status of the request/response data as determined by the classifications. The status attribute is a simplified way to examine a classification as it is just a string and will be one of the following: up, down, block_page, or null/undetermined.

**available**

The probability, represented as a number from 0 to 1, that the given page is available to users connecting via the given ASN as determined by weighting the results from individual classifiers.

**blockPage**

The probability, represented as a number from 0 to 1, that the given page is a known block page sent by some entity on the network as determined by weighting the results from individual classifiers.

**classifiers**

An array of results, one from each classifier queried, which help determine the final classification response.

An individual classifier result will have a name and a weight. These are set by Classifurlr and used to classify a web response. Each classifier result will also have one or more probabilities (available, blockPage, etc.).

Classifurlr uses the individual weight and probabilities together to determine the overall probabilities for the classification. 

### Redirect Example

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/json
    Accept: application/json
    
    {
      "data": {
        "type": "transactions",
        "attributes": {
          "url": "http://cyber.law.harvard.edu",
          "responses": [ {
            "statusCode": 301,
            "responseHeaders": "Location: https://cyber.law.harvard.edu/",
            "rawResults": "",
            "request": {
              "url": "http://cyber.law.harvard.edu",
              "requestHeaders": "Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0",
              "asn": "23650"
            }
          }, {
            "statusCode": 200,
            "responseHeaders": "Content-Type:text/html",
            "rawResults": "<!DOCTYPE html><html><head><title>Berkman Center for Internet and society</title></head><body>...</body></html>",
            "request": {
              "url": "https://cyber.law.harvard.edu/",
              "requestHeaders": "Accept: text/html\r\nAccept-Language: zh-Hans,zh\r\nUser-Agent: Mozilla/5.0 AppleWebKit/537 Chrome/41.0",
              "asn": "23650"
            }
          } ]
        }
      }
    }

Query for Classifiers
---------------------

Send a GET request to /classifiers for a list of all classifiers in the system.

### Example

#### HTTP request

    GET /classifiers HTTP/1.1

#### HTTP response

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "data": [ {
        "id": "1",
        "name": "status_code_classifier",
        "defaultWeight": 0.6
      }, {
        "id": "1",
        "name": "block_page_classifier",
        "defaultWeight": 1.0
      } ]
    }

### classifier response attributes

**id**

The ID of the classifier. 

**name**

The name of the classifier. Set by Classifurlr, it can be used to reference a specific classifier by name when providing custom weights or feedback.

**defaultWeight**

The default weight given to this classifier. It can be overridden in requests to /classify (see below).

Custom weights
--------------

When making a request to /classify, you can override the default weight on any classifier by using the classifiers attribute. The classifiers attribute is an array of objects having a classifier name weight. The weight you provide will override the default weight of the given classifier.

In the following example, the request to /classify is, in effect, turning off the block_page_classifier by setting its weight to 0.0. Even though the page is clearly a block page, the classified result is that it is available.

### Example

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/json
    Accept: application/json
    
    {
      "data": {
        "type": "classifications",
        "attributes": {
          "url": "http://cyber.law.harvard.edu",
          "responses": [ {
            "statusCode": 200,
            "rawResults": "<!DOCTYPE html><html><head><title>The requested page is Forbidden</title></head><body>...</body></html>",
            "screenshot": "data:image/png;base64,iVBOR...==",
            "request": {
              ...
            }
          } ],
          "classifiers": [ {
            "name": "status_code_classifier",
            "weight": 1.0
          }, {
            "name": "block_page_classifier",
            "weight": 0.0
          } ]
        }
      }
    }

#### HTTP response

    HTTP/1.1 200 OK
    Content-Type: application/json

    {
      "data": {
        "type": "classifications",
        "id": "1134",
        "attributes": {
          "status": "up",
          "available": 1.0,
          "blockPage": 0.0,
          "classifiers": [ {
            "name": "status_code_classifier",
            "available": 1.0,
            "weight": 1.0
          }, {
            "name": "block_page_classifier",
            "available": 0.0,
            "blockPage": 1.0,
            "weight": 0.0
          } ]
        }
      }
    }

Errors
------

If a request in invalid or something goes wrong, classifurlr will respond with the appropriate HTTP status code and an error object as per the JSON API spec: http://jsonapi.org/format/#error-objects

### 400 Bad Request

The type and top-level url attributes are required. Also, there must be at least one response object in the responses array. Failure to supply these will result in a 400 Bad Request response.


> Written with [StackEdit](https://stackedit.io/).

