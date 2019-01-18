require_relative 'error'

module SkylabGenesis
  class ClientNilArgument < Error; end

  class Client
    # Attributes
    attr_reader :configuration

    # ------------------------------ Class Methods ------------------------------

    def self.configuration
      @configuration ||= SkylabGenesis::Config.new
    end

    def self.configure
      yield configuration if block_given?
    end

    # ------------------------------ Instance Methods ------------------------------

    def initialize(options = {})
      settings = SkylabGenesis::Client.configuration.settings.merge(options)

      @configuration = SkylabGenesis::Config.new(settings)
    end

    def list_jobs(options = {})
      payload = options

      SkylabGenesis::Request.new(@configuration).get(:jobs, payload)
    end

    def create_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).post(:jobs, payload)
    end

    def get_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).get("jobs/#{options[:id]}", payload)
    end

    def update_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabGenesis::ClientNilArgument, 'job cannot be nil' if options[:job].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).patch("jobs/#{options[:id]}", payload)
    end

    def delete_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).delete("jobs/#{options[:id]}", payload)
    end

    def process_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).post("jobs/#{options[:id]}/process", payload)
    end

    def cancel_job(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).post("jobs/#{options[:id]}/cancel", payload)
    end

    def list_profiles(options = {})
      payload = options

      SkylabGenesis::Request.new(@configuration).get(:profiles, payload)
    end

    def create_profile(options = {})
      raise SkylabGenesis::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).post(:profiles, payload)
    end

    def get_profile(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).get("profiles/#{options[:id]}", payload)
    end

    def update_profile(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabGenesis::ClientNilArgument, 'profile cannot be nil' if options[:profile].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).patch("profiles/#{options[:id]}", payload)
    end

    def delete_profile(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).delete("profiles/#{options[:id]}", payload)
    end

    def list_photos(options = {})
      payload = options

      SkylabGenesis::Request.new(@configuration).get(:photos, payload)
    end

    def create_photo(options = {})
      raise SkylabGenesis::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).post(:photos, payload)
    end

    def get_photo(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).get("photos/#{options[:id]}", payload)
    end

    def update_photo(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?
      raise SkylabGenesis::ClientNilArgument, 'photo cannot be nil' if options[:photo].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).patch("photos/#{options[:id]}", payload)
    end

    def delete_photo(options = {})
      raise SkylabGenesis::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      SkylabGenesis::Request.new(@configuration).delete("photos/#{options[:id]}", payload)
    end
  end
end
