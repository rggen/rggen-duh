# frozen_string_literal: true

RgGen.define_value_extractor(:register_map, :duh, :bit_field, :bit_assignment) do
  extract { |duh| { lsb: duh['bitOffset'], width: duh['bitWidth'] } }
end
