require_relative 'error'
require 'fileutils'
require 'digest'
require 'open-uri'
require 'base64'
require 'net/http'

module SkylabStudio
  class ClientNilArgument < Error; end

  class Client
    # Attributes
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= SkylabStudio::Config.new
    end

    def self.configure
      yield configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = SkylabStudio::Client.configuration.settings.merge(options)

      @configuration = SkylabStudio::Config.new(settings)
    end

    def list_jobs(options = {})
      SkylabStudio::Request.new(@configuration).get(:jobs, options)
    end

    def create_job(options = {})
      validate_argument_presence options, :name
      validate_argument_presence options, :profile_id

      SkylabStudio::Request.new(@configuration).post(:jobs, options)
    end

    def get_job(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).get("jobs/#{options[:id]}", options)
    end

    def get_job_by_name(options = {})
      validate_argument_presence options, :name

      SkylabStudio::Request.new(@configuration).get('jobs/find_by_name', options)
    end

    def update_job(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :job

      SkylabStudio::Request.new(@configuration).patch("jobs/#{options[:id]}", options)
    end

    def queue_job(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).post("jobs/#{options[:id]}/queue", options)
    end

    def fetch_jobs_in_front(options = {})
      SkylabStudio::Request.new(@configuration).get("jobs/#{options[:id]}/jobs_in_front", options)
    end

    def delete_job(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).delete("jobs/#{options[:id]}")
    end

    def cancel_job(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).post("jobs/#{options[:id]}/cancel", options)
    end

    def list_profiles(options = {})
      SkylabStudio::Request.new(@configuration).get(:profiles, options)
    end

    def create_profile(options = {})
      validate_argument_presence options, :name

      SkylabStudio::Request.new(@configuration).post(:profiles, options)
    end

    def get_profile(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).get("profiles/#{options[:id]}", options)
    end

    def update_profile(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :profile

      SkylabStudio::Request.new(@configuration).patch("profiles/#{options[:id]}", options)
    end

    def upload_job_photo(photo_path = nil, job_id = nil)
      validate_argument_presence nil, job_id
      validate_argument_presence nil, photo_path

      upload_photo(photo_path, job_id, 'job')
    end

    def upload_profile_photo(photo_path = nil, profile_id = nil)
      validate_argument_presence nil, :photo_path
      validate_argument_presence nil, :profile_id

      upload_photo(photo_path, profile_id, 'profile')
    end

    def get_photo(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).get("photos/#{options[:id]}", options)
    end

    def get_job_photos(job_identifier, value)
      {
        "job_#{job_identifier}".to_sym => value
      }

      SkylabStudio::Request.new(@configuration).get('phtos/list_for_job', options)
    end

    def update_photo(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :photo

      SkylabStudio::Request.new(@configuration).patch("photos/#{options[:id]}", options)
    end

    def delete_photo(options = {})
      validate_argument_presence options, :id

      SkylabStudio::Request.new(@configuration).delete("photos/#{options[:id]}")
    end

    private

    def get_upload_url(options = { use_cache_upload: false })
      SkylabStudio::Request.new(@configuration).get('photos/upload_url', options)
    end

    def create_photo(options = {})
      SkylabStudio::Request.new(@configuration).post(:photos, options)
    end

    def upload_photo(photo_path, id, model = 'job')
      res = {}
      valid_exts_to_check = %w[.jpg .jpeg .png .webp]

      raise 'Invalid file type: must be of type jpg/jpeg/png/webp' unless valid_exts_to_check.any? { |ext| photo_path.downcase.end_with?(ext) }

      file_size = File.size(photo_path)

      raise 'Invalid file size: must be no larger than 27MB' if file_size > 27 * 1024 * 1024

      photo_name = File.basename(photo_path)
      headers = {}
      md5hash = ''

      # Read file contents to binary
      data = nil
      File.open(photo_path, 'rb') do |file|
        data = file.read
        md5hash = Digest::MD5.hexdigest(data)
      end

      # model - either job or profile (job_id/profile_id)
      photo_data = { "#{model}_id" => id, name: photo_name, 'use_cache_upload' => false }

      if model == 'job'
        job_type = get_job(id: id)['type']

        headers = { 'X-Amz-Tagging' => 'job=photo&api=true' } if job_type == 'regular'
      end

      # Ask studio to create the photo record
      photo_response_json = create_photo(photo_data)

      unless photo_response_json
        raise 'Unable to create the photo object, if creating profile photo, ensure enable_extract and replace_background is set to: True'
      end

      photo_id = photo_response_json['id']

      b64md5 = Base64.strict_encode64([md5hash].pack('H*'))
      payload = {
        'use_cache_upload' => false,
        'photo_id' => photo_id,
        'content_md5' => b64md5
      }

      # Ask studio for a presigned url
      upload_url_resp = get_upload_url(payload)
      upload_url = upload_url_resp['url']

      # PUT request to presigned url with image data
      headers['Content-MD5'] = b64md5

      begin
        uri = URI(upload_url)
        request = Net::HTTP::Put.new(uri, headers)
        request.body = data
        upload_photo_resp = Net::HTTP.start(uri.hostname) {|http| http.request(request) }

        unless upload_photo_resp
          puts 'First upload attempt failed, retrying...'
          retry_count = 0
          # Retry upload

          while retry_count < 3
            upload_photo_resp = Net::HTTP.start(uri.hostname) {|http| http.request(request) }
            if upload_photo_resp
              break # Upload was successful, exit the loop
            elsif retry_count == 2 # Check if retry count is 2 (0-based indexing)
              raise 'Unable to upload to the bucket after retrying.'
            else
              sleep(1) # Wait for a moment before retrying
              retry_count += 1
            end
          end
        end
      rescue StandardError => e
        puts "An exception of type #{e.class} occurred: #{e.message}"
        puts 'Deleting created, but unuploaded photo...'
        delete_photo({ id: photo_id }) if photo_id
      end

      photo_response_json
    end

    def validate_argument_presence(options, key)
      raise SkylabStudio::ClientNilArgument, "#{key} cannot be nil" if options.is_a?(Hash) && options[key].nil?

      raise SkylabStudio::ClientNilArgument, "#{key} cannot be nil" if key.nil?
    end
  end
end
