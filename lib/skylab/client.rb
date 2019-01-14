require_relative 'error'

module Skylab
  class ClientNilArgument < Error; end

  class Client
    # Attributes
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= Skylab::Config.new
    end

    def self.configure
      yield configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = Skylab::Client.configuration.settings.merge(options)

      @configuration = Skylab::Config.new(settings)
    end

    def list_jobs(options = {})
      payload = options

      Skylab::APIRequest.new(@configuration).get(:jobs, payload)
    end

    def create_job(options = {})
      raise Skylab::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).post(:jobs, payload)
    end

    def get_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).get("jobs/#{options[:id]}", payload)
    end

    def update_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise Skylab::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).patch("jobs/#{options[:id]}", payload)
    end

    def delete_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).delete("jobs/#{options[:id]}", payload)
    end

    def process_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).post("jobs/#{options[:id]}/process", payload)
    end

    def cancel_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).post("jobs/#{options[:id]}/cancel", payload)
    end

    def list_profiles(options = {})
      payload = options

      Skylab::APIRequest.new(@configuration).get(:profiles, payload)
    end

    def create_profile(options = {})
      raise Skylab::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).post(:profiles, payload)
    end

    def get_profile(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).get("profiles/#{options[:id]}", payload)
    end

    def update_profile(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise Skylab::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).patch("profiles/#{options[:id]}", payload)
    end

    def delete_profile(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).delete("profiles/#{options[:id]}", payload)
    end

    def list_photos(options = {})
      payload = options

      Skylab::APIRequest.new(@configuration).get(:photos, payload)
    end

    def create_photo(options = {})
      raise Skylab::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).post(:photos, payload)
    end

    def get_photo(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).get("photos/#{options[:id]}", payload)
    end

    def update_photo(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise Skylab::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).patch("photos/#{options[:id]}", payload)
    end

    def delete_photo(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).delete("photos/#{options[:id]}", payload)
    end
  end
end
