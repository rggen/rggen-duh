# frozen_string_literal: true

module RgGen
  module DUH
    class ParseError < RgGen::Core::LoadError
      def initialize(message, file_name, reason)
        super(message, file_name, reason)
      end
    end

    class ValidationFailed < RgGen::Core::LoadError
      def initialize(file_name, errors)
        super("input DUH file is invalid: #{file_name}")
        @errors = errors
      end

      attr_reader :errors

      def to_s
        [
          super,
          *errors.map { |error| "  - #{JSONSchemer::Errors.pretty(error)}" }
        ].join("\n")
      end
    end
  end
end
