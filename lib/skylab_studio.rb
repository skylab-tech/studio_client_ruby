# frozen_string_literal: true

module SkylabStudio
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

require_relative 'skylab_studio/request'
require_relative 'skylab_studio/client'
require_relative 'skylab_studio/config'
require_relative 'skylab_studio/version' unless defined?(Skylab::VERSION)
