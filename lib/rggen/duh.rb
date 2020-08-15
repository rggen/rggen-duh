# frozen_string_literal: true

require 'json'
require 'rb_json5'
require 'json_refs'
require 'json_schemer'
require_relative 'duh/version'
require_relative 'duh/validation_failed'
require_relative 'duh/schema'
require_relative 'duh/loader'

module RgGen
  module DUH
    PLUGIN_NAME = :'rggen-duh'

    EXTRACTORS = [
      'duh/extractor/bit_assignment',
      'duh/extractor/simple_extractors',
      'duh/extractor/type'
    ].freeze

    def self.register_loader(builder)
      builder.register_loader(:register_map, :duh, Loader)
    end

    def self.load_extractors
      EXTRACTORS.each { |file| require_relative(file) }
    end

    def self.default_setup(builder)
      register_loader(builder)
      load_extractors
    end
  end
end
