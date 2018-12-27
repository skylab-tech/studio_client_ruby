# Skylab API

A Ruby client for accessing the Skylab API service.

[skylabtech.ai](http://skylabtech.ai)

## Installation

```bash
$ gem install skylab_api
```

or with Bundler:

```bash
$ gem 'skylab_api'
$ bundle install
```

## Usage


### General

Create a new instance of the client using your API key.

```ruby
require 'rubygems'
require 'skylab_api'

client = SkylabAPI::Client.new(api_key: 'YOUR API KEY', debug: true)
```

### Rails

For a Rails app, create `skylab_api.rb` in `/config/initializers/`
with the following:

```ruby
SkylabAPI::Client.configure do |config|
  config.api_key = 'YOUR API KEY'
  config.debug = true
end
```

In your application code where you want to access Skylab API:

```ruby
begin
  result = SkylabAPI::Client.new.create_job('{}', '/input', '/output')
  puts result
rescue => e
  puts "Error - #{e.class.name}: #{e.message}"
end
```

### List all Jobs

- **page** - *integer* - The page of results to return

```ruby
client.list_jobs()
```

### Get a Job

- **id** - *integer* - The ID of the job

```ruby
client.get_job(id: 123)
```

## Errors

The following errors may be generated:

```ruby
SkylabAPI::ClientInvalidEndpoint - the target URI is probably incorrect
SkylabAPI::ClientInvalidKey - the skylab client API key is invalid
SkylabAPI::ClientBadRequest - the API request is invalid
SkylabAPI::ClientConnectionRefused - the target URI is probably incorrect
SkylabAPI::ClientUnknownError - an unhandled HTTP error occurred
```

## Running tests

Use rspec to run the tests:

```bash
$ rspec
```

## Troubleshooting

### General Troubleshooting

-   Enable debug mode
-   Make sure you're using the latest Ruby client
-   Capture the response data and check your logs &mdash; often this will have the exact error

### Enable Debug Mode

Debug mode prints out the underlying request information as well as the data payload that
gets sent to Skylab API. You will most likely find this information in your logs.
To enable it, simply put `debug: true` as a parameter when instantiating the API object.

```ruby
client = SkylabAPI::Client.new(api_key: 'YOUR API KEY', debug: true)
```

### Response Ranges

Skylab API typically sends responses back in these ranges:

-   2xx – Successful Request
-   4xx – Failed Request (Client error)
-   5xx – Failed Request (Server error)

If you're receiving an error in the 400 response range follow these steps:

-   Double check the data and ID's getting passed to Skylab Core
-   Ensure your API key is correct
-   Log and check the body of the response


## Internal

Build gem with

```bash
gem build skylab_api.gemspec
```
