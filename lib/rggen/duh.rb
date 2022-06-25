# frozen_string_literal: true

require 'json'
require 'rb_json5'
require 'json_refs'
require 'json_schemer'
require_relative 'duh/version'
require_relative 'duh/exceptions'
require_relative 'duh/schema'
require_relative 'duh/loader'

RgGen.setup_plugin :'rggen-duh' do |plugin|
  plugin.version RgGen::DUH::VERSION

  plugin.setup_loader :register_map, :duh do |entry|
    entry.register_loader RgGen::DUH::Loader
  end

  plugin.files [
    'duh/extractor/bit_assignment',
    'duh/extractor/simple_extractors',
    'duh/extractor/type'
  ]
end
