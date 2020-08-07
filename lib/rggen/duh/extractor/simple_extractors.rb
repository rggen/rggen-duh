# frozen_string_literal: true

{
  byte_size: ['range', [:register_block]],
  comment: ['description', [:register]],
  initial_value: ['resetValue', [:bit_field]],
  name: ['name'],
  offset_address: ['addressOffset', [:register_file, :register]]
}.each do |value, (key, layers)|
  RgGen.define_value_extractor(:register_map, :duh, *[layers, value].compact) do
    extract { |duh| duh[key] }
  end
end
