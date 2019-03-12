# Skylab Genesis Ruby Client

[![CircleCI](https://circleci.com/gh/skylab-tech/genesis_client_ruby.svg?style=svg)](https://circleci.com/gh/skylab-tech/genesis_client_ruby)
[![Maintainability](https://api.codeclimate.com/v1/badges/cd6f30ad2b05ecf2ce86/maintainability)](https://codeclimate.com/github/skylab-tech/genesis_client_ruby/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/cd6f30ad2b05ecf2ce86/test_coverage)](https://codeclimate.com/github/skylab-tech/genesis_client_ruby/test_coverage)

A Ruby client for accessing the Skylab Genesis service.

[genesis.skylabtech.ai](https://genesis.skylabtech.ai)

## Installation

```bash
$ gem install skylab_genesis
```

or with Bundler:

```bash
$ gem 'skylab_genesis'
$ bundle install
```

## Usage


### General

Create a new instance of the client using your API key.

```ruby
require 'rubygems'
require 'skylab_genesis'

client = SkylabGenesis::Client.new(api_key: 'YOUR API KEY', debug: true)
```

### Rails

For a Rails app, create `skylab_genesis.rb` in `/config/initializers/`
with the following:

```ruby
SkylabGenesis::Client.configure do |config|
  config.api_key = 'YOUR API KEY'
  config.debug = true
end
```

In your application code where you want to access Skylab API:

```ruby
begin
  result = SkylabGenesis::Client.new.create_job(job: { profile_id: 123 })
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

### Create a Job

- **job** - *hash* - The attributes of the job to create

```ruby
client.create_job(job: { profile_id: 123 })
```

### Get a Job

- **id** - *integer* - The ID of the job

```ruby
client.get_job(id: 123)
```

### Update a Job

- **id** - *integer* - The ID of the job to update
- **job** - *hash* - The attributes of the hob to update

```ruby
client.update_job(id: 123, job: { profile_id: 456 })
```

### Delete a Job

- **id** - *integer* - The ID of the job to delete

```ruby
client.delete_job(id: 123)
```

### Process a Job

- **id** - *integer* - The ID of the job to process

```ruby
client.process_job(id: 123)
```

### Cancel a Job

- **id** - *integer* - The ID of the job to cancel

```ruby
client.cancel_job(id: 123)
```

### List all Profiles

- **page** - *integer* - The page of results to return

```ruby
client.list_profiles()
```

### Create a Profile

- **profile** - *hash* - The attributes of the profile to create

```ruby
client.create_profile(profile: { profile_id: 123 })
```

### Get a Profile

- **id** - *integer* - The ID of the profile

```ruby
client.get_profile(id: 123)
```

### Update a Profile

- **id** - *integer* - The ID of the profile to update
- **profile** - *hash* - The attributes of the hob to update

```ruby
client.update_profile(id: 123, profile: { profile_id: 456 })
```

### Delete a Profile

- **id** - *integer* - The ID of the profile to delete

```ruby
client.delete_profile(id: 123)
```

### List all Photos

- **page** - *integer* - The page of results to return

```ruby
client.list_photos()
```

### Create a Photo

- **photo** - *hash* - The attributes of the photo to create

```ruby
client.create_photo(photo: { photo_id: 123 })
```

### Get a Photo

- **id** - *integer* - The ID of the photo

```ruby
client.get_photo(id: 123)
```

### Update a Photo

- **id** - *integer* - The ID of the photo to update
- **photo** - *hash* - The attributes of the hob to update

```ruby
client.update_photo(id: 123, photo: { photo_id: 456 })
```

### Delete a Photo

- **id** - *integer* - The ID of the photo to delete

```ruby
client.delete_photo(id: 123)
```

## Errors

The following errors may be generated:

```ruby
SkylabGenesis::ClientInvalidEndpoint - the target URI is probably incorrect
SkylabGenesis::ClientInvalidKey - the skylab client API key is invalid
SkylabGenesis::ClientBadRequest - the API request is invalid
SkylabGenesis::ClientConnectionRefused - the target URI is probably incorrect
SkylabGenesis::ClientUnknownError - an unhandled HTTP error occurred
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
client = SkylabGenesis::Client.new(api_key: 'YOUR API KEY', debug: true)
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


## Build

Build gem with

```bash
gem build skylab_genesis.gemspec
```

## Tests

Use rspec to run the tests:

```bash
$ rspec
```
