# frozen_string_literal: true

RgGen.define_value_extractor(:register_map, :duh, :register, :comment) do
  extract { |duh| duh['description'] }
end
