# frozen_string_literal: true

module RgGen
  module DUH
    class ParseError < RgGen::Core::LoadError
      def initialize(message, file_name, reason)
        super(message, file_name, reason)
      end
    end

    class ValidationError < RgGen::Core::LoadError
      def initialize(message, file_name, errors)
        error_info = errors.map(&JSONSchemer::Errors.method(:pretty)).join("\n")
        super(message, file_name, error_info)
      end
    end
  end
end
