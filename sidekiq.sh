#!/bin/sh

bundle exec sidekiq -c 5 -v -q default -q mailers -q glimr_api_calls
