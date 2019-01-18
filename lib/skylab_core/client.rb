require_relative 'error'

module SkylabCore
  class ClientNilArgument < Error; end

  class Client
    # Attributes
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= SkylabCore::Config.new
    end

    def self.configure
      yield configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = SkylabCore::Client.configuration.settings.merge(options)

      @configuration = SkylabCore::Config.new(settings)
    end

    def list_jobs(options = {})
      payload = options

      SkylabCore::Request.new(@configuration).get(:jobs, payload)
    end

    def create_job(options = {})
      raise SkylabCore::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      SkylabCore::Request.new(@configuration).post(:jobs, payload)
    end

    def get_job(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).get("jobs/#{options[:id]}", payload)
    end

    def update_job(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabCore::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      SkylabCore::Request.new(@configuration).patch("jobs/#{options[:id]}", payload)
    end

    def delete_job(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).delete("jobs/#{options[:id]}", payload)
    end

    def process_job(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).post("jobs/#{options[:id]}/process", payload)
    end

    def cancel_job(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).post("jobs/#{options[:id]}/cancel", payload)
    end

    def list_profiles(options = {})
      payload = options

      SkylabCore::Request.new(@configuration).get(:profiles, payload)
    end

    def create_profile(options = {})
      raise SkylabCore::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      SkylabCore::Request.new(@configuration).post(:profiles, payload)
    end

    def get_profile(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).get("profiles/#{options[:id]}", payload)
    end

    def update_profile(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabCore::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      SkylabCore::Request.new(@configuration).patch("profiles/#{options[:id]}", payload)
    end

    def delete_profile(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).delete("profiles/#{options[:id]}", payload)
    end

    def list_photos(options = {})
      payload = options

      SkylabCore::Request.new(@configuration).get(:photos, payload)
    end

    def create_photo(options = {})
      raise SkylabCore::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      SkylabCore::Request.new(@configuration).post(:photos, payload)
    end

    def get_photo(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).get("photos/#{options[:id]}", payload)
    end

    def update_photo(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabCore::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      SkylabCore::Request.new(@configuration).patch("photos/#{options[:id]}", payload)
    end

    def delete_photo(options = {})
      raise SkylabCore::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabCore::Request.new(@configuration).delete("photos/#{options[:id]}", payload)
    end
  end
end
