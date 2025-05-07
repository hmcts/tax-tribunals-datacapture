#!/bin/sh

bundle exec sidekiq -c 5 -v -q glimr_api_calls -q default -q mailers
