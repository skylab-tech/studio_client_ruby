module SkylabCore
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require 'skylab_core/api_request'
require 'skylab_core/client'
require 'skylab_core/config'
require 'skylab_core/version' unless defined?(Skylab::VERSION)
