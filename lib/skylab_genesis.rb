module SkylabGenesis
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require 'skylab_genesis/request'
require 'skylab_genesis/client'
require 'skylab_genesis/config'
require 'skylab_genesis/version' unless defined?(Skylab::VERSION)
