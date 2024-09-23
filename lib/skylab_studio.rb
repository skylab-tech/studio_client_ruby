# frozen_string_literal: true

module SkylabStudio
end

require 'rubygems'
require 'net/http'
require 'net/https'
require 'uri'
require 'json'

# sentry
require 'stackprof'
require 'sentry-ruby'

require_relative 'skylab_studio/request'
require_relative 'skylab_studio/client'
require_relative 'skylab_studio/config'
require_relative 'skylab_studio/version' unless defined?(Skylab::VERSION)

Sentry.init do |config|
  config.dsn = 'https://b2c54fe447391bac2134b1a679050139@o1409269.ingest.us.sentry.io/4507891689717760'

  # get breadcrumbs from logs
  config.breadcrumbs_logger = [:sentry_logger, :http_logger]

  # enable tracing
  # we recommend adjusting this value in production
  config.traces_sample_rate = 1.0

  # enable profiling
  # this is relative to traces_sample_rate
  config.profiles_sample_rate = 1.0
end
