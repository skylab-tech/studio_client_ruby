# frozen_string_literal: true

module SkylabStudio
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require 'skylab_studio/request'
require 'skylab_studio/client'
require 'skylab_studio/config'
require 'skylab_studio/version' unless defined?(Skylab::VERSION)
