#!/bin/sh
curl -H 'Content-Type: application/json' -H 'Accept: application/json' -X POST -d '{"data":{"type":"transactions","attributes":{"url":"http://cyber.law.harvard.edu","responses":[{"statusCode":200,"request":{"url":"http://cyber.law.harvard.edu","asn":"23650"}}]}}}' http://classifurlr.dev.berkmancenter.org/classify
