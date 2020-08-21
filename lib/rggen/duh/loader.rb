# frozen_string_literal: true

module RgGen
  module DUH
    class Loader < Core::RegisterMap::Loader
      support_types [:json5]

      def disable_validation
        @disable_validation = true
      end

      private

      def read_file(file_name)
        duh = JsonRefs.dereference(RbJSON5.load_file(file_name))
        validation? && validate(duh, file_name)
        duh
      end

      def validation?
        !@disable_validation
      end

      def validate(duh, file_name)
        errors = Schema.validate(duh)
        errors.empty? || (raise ValidationFailed.new(file_name, errors))
      end

      SUB_LAYERS = {
        root: [:register_block],
        register_block: [:register_file, :register],
        register_file: [:register],
        register: [:bit_field]
      }.freeze

      def format_sub_layer_data(read_data, layer, _file)
        SUB_LAYERS[layer]&.each_with_object({}) do |sub_layer, sub_layer_data|
          data = __send__("collect_#{sub_layer}_data", read_data)
          data && (sub_layer_data[sub_layer] = data)
        end
      end

      def collect_register_block_data(read_data)
        collect_address_blocks(read_data)
          &.select { |address_block| address_block['usage'] == 'register' }
          &.map { |data| add_parent_and_layer_properties(data, nil, :register_block) }
      end

      def collect_address_blocks(read_data)
        read_data
          .dig('component', 'memoryMaps')
          &.flat_map { |memory_map| memory_map['addressBlocks'] }
          &.compact
      end

      def collect_register_file_data(read_data)
        read_data['registerFiles']&.map do |data|
          add_parent_and_layer_properties(data, read_data, :register_file)
        end
      end

      def collect_register_data(read_data)
        read_data['registers']&.map do |data|
          add_parent_and_layer_properties(data, read_data, :register)
        end
      end

      def collect_bit_field_data(read_data)
        read_data['fields']&.map do |data|
          add_parent_and_layer_properties(data, read_data, :bit_field)
        end
      end

      def add_parent_and_layer_properties(data, parent, layer)
        data.instance_variable_set(:@parent, parent)
        data.instance_variable_set(:@layer, layer)
        class << data
          attr_reader :parent
          attr_reader :layer
        end
        data
      end
    end
  end
end
