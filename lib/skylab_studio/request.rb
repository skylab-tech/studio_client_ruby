# frozen_string_literal: true

require_relative 'error'

module SkylabStudio
  class ClientInvalidEndpoint < Error; end
  class ClientConnectionRefused < Error; end
  class ClientBadRequest < Error; end
  class ClientInvalidKey < Error; end
  class ClientUnknownError < Error; end

  class Request
    attr_reader :response

    def initialize(configuration)
      @configuration = configuration
    end

    def post(endpoint, payload)
      request(Net::HTTP::Post, request_path(endpoint), payload)
    end

    def get(endpoint, payload = nil)
      request(Net::HTTP::Get, request_path(endpoint), payload)
    end

    def delete(endpoint)
      request(Net::HTTP::Delete, request_path(endpoint))
    end

    def put(endpoint, payload)
      request(Net::HTTP::Put, request_path(endpoint), payload)
    end

    def patch(endpoint, payload)
      request(Net::HTTP::Patch, request_path(endpoint), payload)
    end

    private

    def request_path(end_point)
      "/api/public/#{@configuration.api_version}/#{end_point}"
    end

    def use_ssl?
      @configuration.protocol == 'https'
    end

    def request(method_klass, path, payload = {})
      request = method_klass.new(path, 'Content-Type' => 'application/json')

      request.add_field('X-SLT-API-KEY', @configuration.api_key)
      request.add_field('X-SLT-API-CLIENT', @configuration.client_stub)

      payload = payload.to_json

      http          = Net::HTTP.new(@configuration.host, @configuration.port)
      http.use_ssl  = use_ssl?
      http.set_debug_output($stdout) if @configuration.debug

      @response = http.request(request, payload)

      handle_response(@response)
    rescue Errno::ECONNREFUSED
      raise SkylabStudio::ClientConnectionRefused, 'The connection was refused'
    end

    def handle_response(response)
      case response
      when Net::HTTPUnauthorized
        raise SkylabStudio::ClientInvalidKey, 'Invalid api key'
      when Net::HTTPForbidden
        raise SkylabStudio::ClientInvalidKey, 'Invalid api key'
      when Net::HTTPNotFound
        raise SkylabStudio::ClientInvalidEndpoint, 'Resource not found'
      when Net::HTTPBadRequest
        raise SkylabStudio::ClientBadRequest, 'There was an error processing your request'
      when Net::HTTPTooManyRequests
        raise SkylabStudio::ClientBadRequest, 'The rate limit has been met'
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        raise SkylabStudio::ClientUnknownError, 'An error has occurred'
      end
    end
  end
end
