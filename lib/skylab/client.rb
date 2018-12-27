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

    def get_job(options = {})
      raise Skylab::ClientNilArgument, 'id cannot be nil' if options[:id].nil?

      payload = options

      Skylab::APIRequest.new(@configuration).get(:jobs, payload)
    end
  end
end
