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
        duh = load_json5(file_name)
        validation? && validate(duh, file_name)
        duh
      end

      def load_json5(file_name)
        JsonRefs.dereference(RbJSON5.load_file(file_name))
      rescue RbJSON5::ParseError => e
        reason = e.parse_failure_cause.ascii_tree.strip
        raise ParseError.new(e.message, file_name, reason)
      end

      def validation?
        !@disable_validation
      end

      def validate(duh, file_name)
        errors = Schema.validate(duh)
        errors.empty? ||
          (raise ValidationError.new('input DUH file is invalid', file_name, errors))
      end

      SUB_LAYERS = {
        root: [:register_block],
        register_block: [:register_file, :register],
        register_file: [:register],
        register: [:bit_field]
      }.freeze

      def format_sub_layer_data(read_data, layer, _file)
        SUB_LAYERS[layer]&.each_with_object([]) do |sub_layer, sub_layer_data|
          data =
            if layer == :root
              collect_register_block_data(read_data)
            else
              collect_sub_layer_data(read_data, sub_layer)
            end
          data && sub_layer_data.concat([sub_layer].product(data))
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

      KEY_MAP = {
        register_file: 'registerFiles',
        register: 'registers',
        bit_field: 'fields'
      }.freeze

      def collect_sub_layer_data(read_data, sub_layer)
        read_data[KEY_MAP[sub_layer]]&.map do |data|
          add_parent_and_layer_properties(data, read_data, sub_layer)
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
