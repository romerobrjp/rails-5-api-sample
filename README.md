# Rails 5 API example app

## Ruby versions:
- ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
- rbenv 1.1.1-6-g2d7cefe
- Rails 5.1.4

## Entity Relationship Diagram
https://imgur.com/a/FPZ3H

## Tests
- FactoryBot (old FactoryGirl) instead of the fixtures.
- Request specs for integration tests.
- Tests are run in random order so that makes the test suite more robust. If you want to run in the normal order just modify the line `config.order = :random` on `spec_helper.rb`.
- I used the gem 'spring-commands-rspec' to speed up the tests loading and execution.
- Run the tests with `bundle exec spring rspec`. You should see something like that:

`Finished in 2.28 seconds (files took 0.26843 seconds to load)
129 examples, 0 failures

Randomized with seed 49082`

## How to run
- Clone this repo
- Configure the variables in .env
- Configure your hosts file (/etc/hosts in linux) like this: `0.0.0.0 punkapi.com`
- Run`bundle install`
- Run `bundle exec rake db:create`
- Run `bundle exec rake db:migrate`
- [optional] Run the seeds file with `rake db:seed`
- Run `rails s`
- Run `redis-server`

## Requests to the API
- Base URL: http://punkapi.com:3000/v2
- For security reasons, you must send the Accept header with the following value: application/fractal.punk.v2.

## PS
- CORS is configured and enabled.
- Rate Limiting and Throttling are configured.
