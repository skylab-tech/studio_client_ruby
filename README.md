# Skylab Studio Ruby Client

A Ruby client for accessing the Skylab Studio service: [http://studio.skylabtech.ai](https://studio.skylabtech.ai)

For all payload options, consult the [API documentation](https://studio-docs.skylabtech.ai/#tag/job/operation/createJob).

## Requirements

libvips is required to be installed on your machine in order to install skylab-studio (for pyvips).

- [Libvips documentation](https://www.libvips.org/install.html)

## Installation

```bash
$ gem install skylab_studio
```

or with Bundler:

```bash
$ gem 'skylab_studio'
$ bundle install
```

## Usage

### General

Create a new instance of the client using your API key.

```ruby
require 'rubygems'
require 'skylab_studio'

client = SkylabStudio::Client.new(api_key: 'YOUR API KEY', debug: true)
```

### Rails

For a Rails app, create `skylab_studio.rb` in `/config/initializers/`
with the following:

```ruby
SkylabStudio::Client.configure do |config|
  config.api_key = 'YOUR API KEY'
  config.debug = true
end
```

In your application code where you want to access Skylab API:

```ruby
begin
  result = SkylabStudio::Client.new.create_job({ profile_id: 123 })
  puts result
rescue => e
  puts "Error - #{e.class.name}: #{e.message}"
end
```

## Example usage

```ruby
require skylab_studio

client = SkylabStudio::Client.new()
client = SkylabStudio::Client.new({ max_download_concurrency: 5 }) # to set download concurrency (default: 5)

# CREATE PROFILE
profile = client.create_profile({ name: "Test Profile", enable_crop: false, enable_color: false, enable_extract: true })

# CREATE JOB
job_name = "test-job-#{random_uuid}";
job = client.create_job({ name: job_name, profile_id: profile['id'] });

# UPLOAD PHOTO
file_path = "/path/to/photo.jpg";
client.upload_job_photo(file_path, job['id']);

# QUEUE JOB
queued_job = client.queue_job({ id: job['id'], callback_url: "http://server.callback.here/" });

# NOTE: Once the job is queued, it will get queued, processed, and then complete
# We will send a response to the specified callback_url with the output photo download urls
```

```ruby
# OPTIONAL: If you want this SDK to handle photo downloads to a specified output folder

# FETCH COMPLETED JOB (wait until job status is completed)
completed_job = client.get_job(queued_job['id']);

# DOWNLOAD COMPLETED JOB PHOTOS
photos_list = completed_job['photos'];
client.download_all_photos(photos_list, completed_job['profile'], "photos/output/");

# OR, download single photo
client.download_photo(photos_list[0]["id"], "/output/folder/"); # keep original filename
client.download_photo(photos_list[0]["id"], "/output/folder/new_name.jpg"); # rename output image

```

### List all Jobs

- **page** - _integer_ - The page of results to return

```ruby
client.list_jobs()
```

### Create a Job

- **job** - _hash_ - The attributes of the job to create

```ruby
client.create_job({ name: "TEST JOB", profile_id: 123 })
```

### Get a Job

- **id** - _integer_ - The ID of the job

```ruby
client.get_job(123)
```

### Get a Job by name

- **options** - _hash_ - The hash with job name

```ruby
client.get_job({ name: "TEST JOB" })
```

### Update a Job

- **id** - _integer_ - The ID of the job to update
- **options** - _hash_ - The attributes of the job to update

```ruby
client.update_job(id: 123, { name: "new job name", profile_id: 456 })
```

### Queue a Job

- **options** - _hash_ - The attributes of the job to queue

```ruby
client.queue_job({ id: 123, callback_url: "http://callback.url.here/ })
```

### Fetch Jobs in front

- **job_id** - _hash_ - The ID of the job

```ruby
client.fetch_jobs_in_front(123)
```

### Delete a Job

- **id** - _integer_ - The ID of the job to delete

```ruby
client.delete_job(123)
```

### Cancel a Job

- **id** - _integer_ - The ID of the job to cancel

```ruby
client.cancel_job(123)
```

### List all Profiles

- **page** - _integer_ - The page of results to return

```ruby
client.list_profiles()
```

### Create a Profile

- **options** - _hash_ - The attributes of the profile to create

```ruby
client.create_profile({ name: "New profile", enable_crop: false, enable_color: false, enable_extract: true })
```

### Get a Profile

- **id** - _integer_ - The ID of the profile

```ruby
client.get_profile(123)
```

### Update a Profile

- **profile_id** - _integer_ - The ID of the profile to update
- **options** - _hash_ - The attributes of the profile to update

```ruby
client.update_profile(123, { name: "new profile name", enable_color: true })
```

### Upload Job Photo

This method handles validating a photo, creating a photo object and uploading it to your job/profile's s3 bucket. If the bucket upload process fails, it retries 3 times and if failures persist, the photo object is deleted.

- **photo_path** - _string_ - The current local file path of the image file
- **job_id** - _integer_ - The ID of the job to associate the image file upload to

```ruby
client.upload_job_photo('/path/to/photo.jpg', 123)
```

### Upload Profile Photo

This function handles validating a background photo for a profile. Note: enable_extract and replace_background (profile attributes) MUST be true in order to create background photos. Follows the same upload process as upload_job_photo.

- **photo_path** - _string_ - The current local file path of the image file
- **profile_id** - _integer_ - The ID of the profile to associate the image file upload to

```ruby
client.upload_profile_photo('/path/to/photo.jpg', 123)
```

### Get a Photo

- **id** - _integer_ - The ID of the photo

```ruby
client.get_photo(123)
```

### Delete a Photo

- **id** - _integer_ - The ID of the photo to delete

```ruby
client.delete_photo(123)
```

### Get job photos

- **id** - _integer_ - The ID of the job to get photos from

```ruby
client.get_job_photos(123)
```

### Download photo(s)

This function handles downloading the output photos to a specified directory.

```ruby
photos_list = completed_job['photos']

download_results = client.download_all_photos(photos_list, completed_job['profile'], "/output/folder/path")

Output:
{'success_photos': ['1.JPG'], 'errored_photos': []}
```

OR

```ruby
client.download_photo(photo_id, "/output/folder/path") # download photo with original filename to a directory
client.download_photo(photo_id, "/output/folder/test.jpg") # download photo with new filename to a directory
```

## Errors

The following errors may be generated:

```ruby
SkylabStudio::ClientInvalidEndpoint - the target URI is probably incorrect
SkylabStudio::ClientInvalidKey - the skylab client API key is invalid
SkylabStudio::ClientBadRequest - the API request is invalid
SkylabStudio::ClientConnectionRefused - the target URI is probably incorrect
SkylabStudio::ClientUnknownError - an unhandled HTTP error occurred
```

## Troubleshooting

### General Troubleshooting

- Enable debug mode
- Make sure you're using the latest Ruby client
- Capture the response data and check your logs &mdash; often this will have the exact error

### Enable Debug Mode

Debug mode prints out the underlying request information as well as the data payload that
gets sent to Skylab API. You will most likely find this information in your logs.
To enable it, simply put `debug: true` as a parameter when instantiating the API object.

```ruby
client = SkylabStudio::Client.new(api_key: 'YOUR API KEY', debug: true)
```

### Response Ranges

Skylab API typically sends responses back in these ranges:

- 2xx – Successful Request
- 4xx – Failed Request (Client error)
- 5xx – Failed Request (Server error)

If you're receiving an error in the 400 response range follow these steps:

- Double check the data and ID's getting passed to Skylab Core
- Ensure your API key is correct
- Log and check the body of the response

## Build

Build gem with

```bash
gem build skylab_studio.gemspec
```

## Tests

Use rspec to run the tests:

```bash
$ rspec
```
