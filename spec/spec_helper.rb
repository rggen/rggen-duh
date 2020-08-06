# frozen_string_literal: true

require 'bundler/setup'
require 'stringio'
require 'rggen/devtools/spec_helper'
require 'support/shared_contexts'

require 'rggen/core'

builder = RgGen::Core::Builder.create
RgGen.builder(builder)

require 'rggen/default_register_map'
RgGen::DefaultRegisterMap.default_setup(builder)

RSpec.configure do |config|
  RgGen::Devtools::SpecHelper.setup(config)
end

require 'rggen/duh'
