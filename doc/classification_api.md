Classification API
==================

This API allows any third party to submit HTTP transaction data (request/response data) for a URL and retrieve our best guess of the availability of that URL.

Classifurlr uses many classification modules together in order to make a determination. Some modules can use machine learning and user feedback to improve.

Query for classification
------------------------

Send POST requests to /classify to let us know that you would like a classification of one or more transactions with a URL. Send as much data as you have (including historic data) because each classification module will use what it can.

POSTs to /classify should have the Content-Type: application/json.

The content should follow the [HTTP Archive (HAR) specification](http://www.softwareishard.com/blog/har-12-spec/) with the addition of:

* an "_asn" attribute in each request object
* "_raw" & "_screenshot" attributes in each response.content object
* an optional "_error" attribute in each response object if an error was encountered while making the request

Each current and historic session should get its own page object in the pages array. Even though they will all have the same URL, for the purposes of classification, a session from a different time is a different page in this spec.

### Basic Example

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/json
    Accept: application/json
    
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

#### HTTP response

    HTTP/1.1 201 Created
    Content-Type: application/json

      {
        "data": {
          "type": "classifications",
          "id": "1134",
          "attributes": {
            "status": "up",
            "statusConfidence": 1.0
          },
          "relationships": {
            "classifiers": {
              "data": [
                { "type": "StatusCodeClassifier", "id": "4096" },
                { "type": "BlockPageClassifier", "id": "4097" }
              ]
            }
          }
        },
        "included": [ {
          "type": "StatusCodeClassifier",
          "id": "4096",
          "attributes": {
            "status": "up",
            "weight": 0.6
          }
        } , {
          "type": "BlockPageClassifier",
          "id": "4097",
          "attributes": {
            "status": "up",
            "weight": 1.0
          }
        } ]
      }

### Notable classification request attributes

This section has notes on attributes which are part of the HAR spec as well as extensions to the HAR spec which classifurlr needs to properly classify request data.

#### log

The root object of an HTTP Archive. It contains the pages and entities arrays.

#### pages

This object represents list of exported pages. In the context of classifurlr, they should all be to the same web page though they can be from different times and ASNs.

Historic data can be sent and may be useful to some classifiers.

**startedDateTime**

Date and time stamp for the beginning of the page load (ISO 8601).

**id**

Unique identifier of a page within the log. Entries use it to refer the parent page.

#### entries

This object represents an array with all HTTP request & response data relating to a page you wish to classify.

Multiple entries with different URLs from a single session (page) can also be sent and will allow classifiers to follow redirects.

**pageref**

Reference to the parent page's id. Optional and can be left out if there is only one page in the submission, e.g., no historic data.

**startedDateTime**

Date and time stamp of the request start (ISO 8601).

**time**

Total elapsed time of the request in milliseconds. This is the sum of all timings available in the timings object (i.e. not including -1 values).

**request**

Detailed info about the request.

**response**

Detailed info about the response.

**cache**

This object contains info about a request coming from browser cache. It can contain beforeRequest and afterRequest attributes.

For more information, please see the HAR spec: http://www.softwareishard.com/blog/har-12-spec/#cache

**timings**

This object describes various phases within request-response round trip. All times are specified in milliseconds. It contains attributes such as: connect, send, wait, and receive.

For more information, please see the HAR spec: http://www.softwareishard.com/blog/har-12-spec/#timings

**serverIPAddress**

IP address of the server that was connected (result of DNS resolution).

**_certificates**

An array of PEM or DER-encoded certificates accepted during the request.

This is a custom extension to the spec and begins with an underscore.

#### request

**_asn**

The Autonomous System Number for the ISP to which the original requesting machine connected.

This is a custom extension to the spec and begins with an underscore.

**method**

Request method (GET, POST, ...).

**url**

Absolute URL to which the given request and response data applies (fragments are not included).

**httpVersion**

Request HTTP Version.

**headers**

List of request headers as objects, each containing name and value attributes.

**cookies**

List of request cookie objects, each containing at least name and value attributes. Other attributes are allowed and described in the HAR spec.

**headersSize**

Total number of bytes from the start of the HTTP request message until (and including) the double CRLF before the body. Set to -1 if the info is not available.

**bodySize**

Size of the request body (POST data payload) in bytes.

#### response

**status**

HTTP status code returned in the response.

**statusText**

HTTP response status description.

**httpVersion**

Response HTTP Version.

**headers**

List of response headers as objects, each containing name and value attributes.

If you are sending more than one entry with your transaction data, it is strongly recommended that you include the response headers attribute in each response object (as well as matching url in the related request object). This way, the classifiers can differentiate between, e.g., redirects, historic data, or unrelated requests.

**cookies**

List of response cookie objects, each containing at least name and value attributes. Other attributes are allowed and described in the HAR spec.

**content**

This object describes details about response content.

The following four attributes (size, mimeType, _raw, & _screenshot) are part of the content object.

**content.size**

Length of the returned content in bytes. Should be equal to response.bodySize if there is no compression and bigger when the content has been compressed.

**content.mimeType**

MIME type of the response text (value of the Content-Type response header). The charset attribute of the MIME type is included (if available).

**content._raw**

The full HTML of response body if the mimeType is HTML.

This is a custom extension to the spec and begins with an underscore.

**content._screenshot**

Data URI of an image of the rendered response, if available.

This is a custom extension to the spec and begins with an underscore.

**headersSize**

Total number of bytes from the start of the HTTP response message until (and including) the double CRLF before the body. Set to -1 if the info is not available.

**bodySize**

Size of the request body (POST data payload) in bytes.

**_errors**

Any errors encountered on the physical, network, or transport layers during the request.

This is a custom extension to the spec and begins with an underscore.

### classification response attributes

**id**

The ID of the classification. Set by Classifurlr, it can be used to provide feedback after further analysis or human interpretation.

**status**

The status of the request/response data as determined by analyzing the results of individual classifiers. The status attribute is a simplified way to examine a classification as it is a string and will be "up", "down".

**statusConfidence**

Confidence, as determined by classifying test data, represented as a number from 0 to 1, that the value given for status is accurate. 

**classifiers**

An array of results, one from each classifier queried, which help determine the final classification response.

An individual classifier result will have a status and a weight. The data appears in the "included" section of the response. These are set by Classifurlr and used to classify a web response. 

Classifurlr uses the individual statusus and weights together to determine the overall status and confidence for the classification. 

### Redirect Example

This example shows what a HAR with a redirect looks like. There is still a single page, the original URL requested. The first response entity shows a 301 status code and a Location header, pointing to the HTTPS version of the website. Upon following the redirect, the real content comes back. Both entities reference the same page id.

Only pertinent attributes are shown.

#### HTTP request

    POST /classify HTTP/1.1
    Content-Type: application/json
    Accept: application/json
    
    {
      "log": {
        "pages": [ { "id": "page_1", } ],
        "entries": [ {
          "pageref": "page_1",
          "request": {
            "method": "GET",
            "url": "http://cyber.law.harvard.edu/"
          },
          "response": {
            "status": 301,
            "statusText": "Moved Permanently",
            "headers": [ {
              "name": "Location",
              "value": "https://cyber.law.harvard.edu/"
            } ]
          }
        }, {
          "pageref": "page_1",
          "request": {
            "method": "GET",
            "url": "https://cyber.law.harvard.edu/"
          },
          "response": {
            "status": 200,
            "statusText": "OK"
            "content": {
              "size": 37120,
              "mimeType": "text/html",
              "_raw": "<!DOCTYPE html><html><head><title>Berkman Klein Center for Internet and society</title></head><body>...</body></html>",
            }
          }
        } ]
      }
    }

#### HTTP response

    HTTP/1.1 201 Created
    Content-Type: application/json

      {
        "data": {
          "type": "classifications",
          "id": "1134",
          "attributes": {
            "status": "up",
            "statusConfidence": 1.0
          },
          "relationships": {
            "classifiers": {
              "data": [
                { "type": "StatusCodeClassifier", "id": "4096" },
                { "type": "BlockPageClassifier", "id": "4097" }
              ]
            }
          }
        },
        "included": [ {
          "type": "StatusCodeClassifier",
          "id": "4096",
          "attributes": {
            "status": "up",
            "weight": 0.6
          }
        } , {
          "type": "BlockPageClassifier",
          "id": "4097",
          "attributes": {
            "status": "up",
            "weight": 1.0
          }
        } ]
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
        "type": "StatusCodeClassifier",
        "defaultWeight": 0.6
      }, {
        "type": "BlockPageClassifier",
        "defaultWeight": 1.0
      } ]
    }

### classifier response attributes

**name**

The name of the classifier. Set by Classifurlr, it can be used to reference a specific classifier by name when providing custom weights or feedback.

**defaultWeight**

The default weight given to this classifier. It can be overridden in requests to /classify (see below).

Custom weights
--------------

When making a request to /classify, you can override the default weight on any classifier by using the classifiers attribute. The classifiers attribute is an array of objects having a classifier name weight. The weight you provide will override the default weight of the given classifier.

In the following example, the request to /classify is, in effect, turning off the BlockPageClassifier by setting its weight to 0.0. Even though the page is clearly a block page, the classified result is that it is available.

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
            "type": "StatusCodeClassifier",
            "weight": 1.0
          }, {
            "type": "BlockPageClassifier",
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
          "unavailable": 0.0,
          "blocked": 0.0,
          "classifiers": [ {
            "type": "StatusCodeClassifier",
            "available": 1.0,
            "unavailable": 0.0,
            "weight": 1.0
          }, {
            "type": "BlockPageClassifier",
            "blocked": 1.0,
            "weight": 0.0
          } ]
        }
      }
    }

Errors
------

If a request in invalid or something goes wrong, classifurlr will respond with the appropriate HTTP status code and an error object as per the JSON API spec: http://jsonapi.org/format/#error-objects

### 400 Bad Request

The type and top-level url attributes are required. Also, there must be at least one response object in the responses array. Failure to supply these will result in a 400 Bad Request response and a error object similar to:

    {
      "errors": [ {
        "status": "400",
        "title": "Bad Request"
      }, {
        "detail": "url attribute is required"
      }, {
        "detail": "at least one response object is required"
      } ]
    }

### 500 Internal Server Error

When an unexpected condition is encountered while attempting to classify transaction data, classifurlr will return a 500 HTTP status code. There is no guaranteed content or content format in the response.

### individual classifier errors

If a request to classifurlr has valid transaction data but a status cannot be determined with enough confidence, classifurlr will return a 501 HTTP status code and a JSON API document containing both a data object and an errors object. The data object will contain information on which classifiers were attempted and, possibly, partial results. It is possible that, at a later date, classifurlr would be able to make a determination given the same transaction data because of new classifiers or better tuned existing classifiers.

    {
      "data": {
        "type": "classifications",
        "id": "1134",
        "attributes": {
          "status": "undetermined",
          "available": 0.0,
          "unavailable": 0.0,
          "blockPage": 0.0,
          "classifiers": [ {
            "type": "StatusCodeClassifier",
            "available": 0.0,
            "unavailable": 0.0,
            "weight": 0.6
          }, {
            "type": "BlockPageClassifier",
            "blocked": 0.0,
            "weight": 1.0
          } ]
        }
      },
      "errors": [ {
        "source": "StatusCodeClassifier",
        "detail": "missing status code"
      } ]
    }

> Written with [StackEdit](https://stackedit.io/).

