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
      SkylabGenesis::Request.new(@configuration).get(:jobs, payload: options)
    end

    def create_job(options = {})
      validate_argument_presence options, :job

      SkylabGenesis::Request.new(@configuration).post(:jobs, payload: options)
    end

    def get_job(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).get("jobs/#{options[:id]}", payload: options)
    end

    def update_job(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :job

      SkylabGenesis::Request.new(@configuration).patch("jobs/#{options[:id]}", payload: options)
    end

    def delete_job(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).delete("jobs/#{options[:id]}")
    end

    def process_job(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).post("jobs/#{options[:id]}/process", payload: options)
    end

    def cancel_job(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).post("jobs/#{options[:id]}/cancel", payload: options)
    end

    def list_profiles(options = {})
      SkylabGenesis::Request.new(@configuration).get(:profiles, payload: options)
    end

    def create_profile(options = {})
      validate_argument_presence options, :profile

      SkylabGenesis::Request.new(@configuration).post(:profiles, payload: options)
    end

    def get_profile(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).get("profiles/#{options[:id]}", payload: options)
    end

    def update_profile(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :profile

      SkylabGenesis::Request.new(@configuration).patch("profiles/#{options[:id]}", payload: options)
    end

    def delete_profile(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).delete("profiles/#{options[:id]}")
    end

    def list_photos(options = {})
      SkylabGenesis::Request.new(@configuration).get(:photos, payload: options)
    end

    def create_photo(options = {})
      validate_argument_presence options, :photo

      SkylabGenesis::Request.new(@configuration).post(:photos, payload: options)
    end

    def get_photo(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).get("photos/#{options[:id]}", payload: options)
    end

    def update_photo(options = {})
      validate_argument_presence options, :id
      validate_argument_presence options, :photo

      SkylabGenesis::Request.new(@configuration).patch("photos/#{options[:id]}", payload: options)
    end

    def delete_photo(options = {})
      validate_argument_presence options, :id

      SkylabGenesis::Request.new(@configuration).delete("photos/#{options[:id]}")
    end

    private

    def validate_argument_presence(options, key)
      raise SkylabGenesis::ClientNilArgument, "#{key} cannot be nil" if options[key].nil?
    end
  end
end
