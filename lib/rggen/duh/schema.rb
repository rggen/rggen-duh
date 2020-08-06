# frozen_string_literal: true

module RgGen
  module DUH
    module Schema
      class << self
        def validate(duh)
          schema.validate(duh).to_a
        end

        private

        def schema
          @schema ||= build_schema
        end

        def build_schema
          schema_data = JSON.parse(File.read(File.join(__dir__, 'schema.json')))
          resolver = ->(uri) { uri.path == 'defs' && schema_data['defs'] || nil }
          JSONSchemer.schema(schema_data['component'], ref_resolver: resolver)
        end
      end
    end
  end
end
