classifurlr
===========

Given request and response data, attempts to determine likelihood that page is available vs. down or blocked.

ruby version
------------

ruby: 2.2.4
rails: 4.2.3

system dependencies
-------------------

* PostgreSQL

configuration
-------------

    $ bundle install
    $ cp config/database.yml.example config/database.yml (and edit)
    $ cp config/secrets.yml.example config/secrets.yml (and edit)
    $ rake db:setup

how to run the test suite
-------------------------

    $ rake db:setup RAILS_ENV=test
    $ bin/rspec spec


> Written with [StackEdit](https://stackedit.io/).

