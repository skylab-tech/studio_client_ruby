module Skylab
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require 'skylab/api_request'
require 'skylab/client'
require 'skylab/config'
require 'skylab/version' unless defined?(Skylab::VERSION)
