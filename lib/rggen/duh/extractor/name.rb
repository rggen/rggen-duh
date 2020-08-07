# frozen_string_literal: true

RgGen.define_value_extractor(:register_map, :duh, :name) do
  extract { |duh| duh['name'] }
end
