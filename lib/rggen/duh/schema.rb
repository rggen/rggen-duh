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
          schema_data = read_schema
          resolver = ->(uri) { uri.path == '/defs' && schema_data['defs'] || nil }
          JSONSchemer.schema(schema_data['component'], ref_resolver: resolver)
        end

        def read_schema
          path = File.join(__dir__, 'duh-schema', 'schema.json')
          JSON.parse(File.read(path))
        end
      end
    end
  end
end
