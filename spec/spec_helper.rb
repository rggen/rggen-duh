# frozen_string_literal: true

require 'bundler/setup'
require 'stringio'
require 'rggen/devtools/spec_helper'
require 'support/shared_contexts'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
builder.plugin_manager.activate_plugin_by_name(:'rggen-default-register-map')

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/duh'
builder.plugin_manager.activate_plugin_by_name(:'rggen-duh')

RGGEN_ROOT = ENV['RGGEN_ROOT'] || File.expand_path('../..', __dir__)
RGGEN_DUH_ROOT = File.expand_path('..', __dir__)
RGGEN_SAMPLE_DIRECTORY = File.join(RGGEN_ROOT, 'rggen-sample')
