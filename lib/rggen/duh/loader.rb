# frozen_string_literal: true

module RgGen
  module DUH
    class Loader < Core::RegisterMap::Loader
      support_types [:json5]

      private

      def read_file(file_name)
        duh = read_duh(file_name)
        validate(duh, file_name)
      end

      def read_duh(file_name)
        JsonRefs.call(RbJSON5.load_file(file_name))
      end

      def validate(duh, file_name)
        errors = Schema.validate(duh)
        errors.empty? && duh ||
          (raise ValidationFailed.new(file_name, errors))
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
        read_data
          .dig('component', 'memoryMaps')
          &.flat_map { |memory_map| memory_map['addressBlocks'] }
          &.compact
          &.select { |address_block| address_block['usage'] == 'register' }
      end

      def collect_register_file_data(read_data)
        read_data['registerFiles']
      end

      def collect_register_data(read_data)
        read_data['registers']
      end

      def collect_bit_field_data(read_data)
        read_data['fields']
      end
    end
  end
end
