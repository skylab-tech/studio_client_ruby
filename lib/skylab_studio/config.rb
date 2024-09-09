# frozen_string_literal: true

require_relative 'version'

module SkylabStudio
  class Config
    attr_accessor :settings

    DEFAULT_URL = 'https://studio-staging.skylabtech.ai'

    def self.defaults
      source = URI.parse(DEFAULT_URL)

      {
        url: DEFAULT_URL,
        api_key: nil,
        protocol: source.scheme,
        host: source.host,
        port: source.port,
        api_version: 'v1',
        debug: true,
        client_stub: "ruby-#{VERSION}",
        max_download_concurrency: 5
      }
    end

    def initialize(options = {})
      @settings = SkylabStudio::Config.defaults.merge(options)
    end

    def method_missing(meth, *args, &block)
      meth_str = meth.to_s

      if meth_str.include?('=')
        # If this is a write attempt, see if we can write to that key
        meth_sym = meth_str.delete('=').to_sym

        has?(meth_sym) ? @settings[meth_sym] = args[0] : super
      else
        # It's a read attempt, see if that key exists
        has?(meth) ? @settings[meth] : super
      end
    end

    def respond_to_missing?(meth, include_private = false)
      has?(meth) || super
    end

    private

    def has?(key)
      @settings.key?(key)
    end
  end
end
