# frozen_string_literal: true

require_relative 'error'
require 'fileutils'
require 'digest'
require 'open-uri'
require 'base64'
require 'net/http'
require 'vips'
require 'concurrent'

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

    def get_job(job_id)
      validate_argument_presence nil, :job_id

      SkylabStudio::Request.new(@configuration).get("jobs/#{job_id}")
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

    def delete_job(job_id)
      validate_argument_presence nil, :job_id

      SkylabStudio::Request.new(@configuration).delete("jobs/#{job_id}")
    end

    def cancel_job(job_id)
      validate_argument_presence nil, :job_id

      SkylabStudio::Request.new(@configuration).post("jobs/#{job_id}/cancel", nil)
    end

    def list_profiles(options = {})
      SkylabStudio::Request.new(@configuration).get(:profiles, options)
    end

    def create_profile(options = {})
      validate_argument_presence options, :name

      SkylabStudio::Request.new(@configuration).post(:profiles, options)
    end

    def get_profile(profile_id)
      validate_argument_presence nil, :profile_id

      SkylabStudio::Request.new(@configuration).get("profiles/#{profile_id}")
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

    def get_photo(photo_id)
      validate_argument_presence nil, :photo_id

      SkylabStudio::Request.new(@configuration).get("photos/#{photo_id}")
    end

    def get_job_photos(job_id)
      SkylabStudio::Request.new(@configuration).get('photos/list_for_job', { job_id: job_id })
    end

    def update_photo(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :photo

      SkylabStudio::Request.new(@configuration).patch("photos/#{options[:id]}", options)
    end

    def delete_photo(job_id)
      validate_argument_presence nil, :job_id

      SkylabStudio::Request.new(@configuration).delete("photos/#{job_id}")
    end

    def download_photo(photo_id, output_path, profile: nil, options: {})
      file_name = ''

      unless Dir.exist?(output_path)
        # Must be a file path - separate output_path and file_name
        file_name = File.basename(output_path)
        output_path = File.dirname(output_path) || ''
      end

      begin
        photo = get_photo(photo_id)
        profile_id = photo['job']['profileId']

        file_name = photo['name'] if file_name.empty?

        profile ||= get_profile(profile_id)

        is_extract = profile['enableExtract'].to_s == 'true'
        replace_background = profile['replaceBackground'].to_s == 'true'
        is_dual_file_output = profile['dualFileOutput'].to_s == 'true'
        profile['enableStripPngMetadata'].to_s
        bgs = options[:bgs]

        # Load output image
        image_buffer = download_image_async(photo['retouchedUrl'])
        image = Vips::Image.new_from_buffer(image_buffer, '')

        if is_extract # Output extract image
          png_file_name = "#{File.basename(file_name, '.*')}.png"

          # Dual File Output will provide an image in the format specified in the outputFileType field
          # and an extracted image as a PNG.
          image.write_to_file(File.join(output_path, png_file_name)) if is_dual_file_output

          download_replaced_background_image(file_name, image, output_path, profile: profile, bgs: bgs) if replace_background

          # Regular Extract output
          image.write_to_file(File.join(output_path, png_file_name)) unless is_dual_file_output || replace_background
        else # Non-extracted regular image output
          image.write_to_file(File.join(output_path, file_name))
        end

        puts "Successfully downloaded: #{file_name}"
        [file_name, true]
      rescue StandardError => e
        error_msg = "Failed to download photo id: #{photo_id} - #{e}"
        raise error_msg if options[:return_on_error].nil?

        [file_name, false]
      end
    end

    def download_all_photos(photos_list, profile, output_path)
      raise 'Invalid output path' unless Dir.exist?(output_path)

      success_photos = []
      errored_photos = []
      bgs = []

      begin
        profile = get_profile(profile['id'])
        bgs = download_bg_images(profile) if profile && profile['photos']&.any?

        photo_ids = photos_list.map { |photo| photo['id'].to_s }.compact

        pool = Concurrent::FixedThreadPool.new(@configuration.settings[:max_download_concurrency])
        download_tasks = []
        photo_options = { return_on_error: true, bgs: bgs }
        photo_ids.each do |photo_id|
          download_tasks << Concurrent::Future.execute(executor: pool) do
            download_photo(photo_id.to_i, output_path, profile: profile, options: photo_options)
          end
        end

        # Wait for all download tasks to complete
        results = download_tasks.map(&:value)
        results.each do |result|
          if result[1]
            success_photos << result[0]
          else
            errored_photos << result[0]
          end
        end

        { success_photos: success_photos, errored_photos: errored_photos }
      rescue StandardError => e
        warn e

        { success_photos: success_photos, errored_photos: errored_photos }
      end
    end

    private

    def get_upload_url(options = { use_cache_upload: false })
      SkylabStudio::Request.new(@configuration).get('photos/upload_url', options)
    end

    def create_photo(options = {})
      SkylabStudio::Request.new(@configuration).post(:photos, options)
    end

    def upload_photo(photo_path, id, model = 'job')
      valid_exts_to_check = %w[.jpg .jpeg .png .webp]

      raise 'Invalid file type: must be of type jpg/jpeg/png/webp' unless valid_exts_to_check.any? { |ext| photo_path.downcase.end_with?(ext) }

      file_size = File.size(photo_path)

      raise 'Invalid file size: must be no larger than 27MB' if file_size > 27 * 1024 * 1024

      photo_name = File.basename(photo_path)
      photo_ext = File.extname(photo_name)
      headers = {}
      md5hash = ''

      # Read file contents to binary
      data = nil
      File.open(photo_path, 'rb') do |file|
        data = file.read
        md5hash = Digest::MD5.hexdigest(data)
      end

      # model - either job or profile (job_id/profile_id)
      photo_data = { "#{model}_id": id, name: "#{photo_name}#{photo_ext}", path: photo_path, 'use_cache_upload': false }

      if model == 'job'
        job_type = get_job(id)['type']

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
        upload_photo_resp = Net::HTTP.start(uri.hostname) { |http| http.request(request) }

        unless upload_photo_resp
          puts 'First upload attempt failed, retrying...'
          retry_count = 0
          # Retry upload

          while retry_count < 3
            upload_photo_resp = Net::HTTP.start(uri.hostname) { |http| http.request(request) }
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

    def download_image_async(image_url)
      raise "Invalid retouchedUrl: \"#{image_url}\" - Please ensure the job is complete" unless image_url.start_with?('http', 'https')

      begin
        uri = URI(image_url)
        response = Net::HTTP.get_response(uri)

        if response.is_a?(Net::HTTPSuccess)
          response.body

        else
          puts "Error downloading image: #{response.message}"
          nil
        end
      rescue StandardError => e
        puts "Error downloading image: #{e.message}"
        nil
      end
    end

    def download_bg_images(profile)
      temp_bgs = []

      bg_photos = profile['photos'].select { |photo| photo['jobId'].nil? }

      bg_photos.each do |bg|
        bg_buffer = download_image_async(bg['originalUrl'])
        bg_image = Vips::Image.new_from_buffer(bg_buffer, '')
        temp_bgs << bg_image
      end

      temp_bgs
    end

    def download_replaced_background_image(file_name, input_image, output_path, profile: nil, bgs: nil)
      output_file_type = profile&.[]('outputFileType') || 'png'

      bgs = download_bg_images(profile) if bgs.nil? && !profile.nil? && profile&.[]('photos')&.any?

      alpha_channel = input_image[3]
      rgb_channel = input_image[0..2]
      rgb_cutout = rgb_channel.bandjoin(alpha_channel)

      if bgs&.any?
        bgs.each_with_index do |bg_image, i|
          new_file_name = if i.zero?
                            "#{File.basename(file_name,
                                             '.*')}.#{output_file_type}"
                          else
                            "#{File.basename(file_name,
                                             '.*')} (#{i + 1}).#{output_file_type}"
                          end
          resized_bg_image = bg_image.thumbnail_image(input_image.width, height: input_image.height, crop: :centre)
          result_image = resized_bg_image.composite2(rgb_cutout, :over)
          result_image.write_to_file(File.join(output_path, new_file_name))
        end
      end

      true
    rescue StandardError => e
      error_msg = "Error downloading background image: #{e.message}"
      raise error_msg
    end

    def validate_argument_presence(options, key)
      raise SkylabStudio::ClientNilArgument, "#{key} cannot be nil" if options.is_a?(Hash) && options[key].nil?

      raise SkylabStudio::ClientNilArgument, "#{key} cannot be nil" if key.nil?
    end
  end
end
