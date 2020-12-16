# frozen_string_literal: true

require 'json'
require 'rb_json5'
require 'json_refs'
require 'json_schemer'
require_relative 'duh/version'
require_relative 'duh/exceptions'
require_relative 'duh/schema'
require_relative 'duh/loader'

module RgGen
  module DUH
    extend Core::Plugin

    setup_plugin :'rggen-duh' do |plugin|
      plugin.register_loader :register_map, :duh, Loader
      plugin.files [
        'duh/extractor/bit_assignment',
        'duh/extractor/simple_extractors',
        'duh/extractor/type'
      ]
    end
  end
end
