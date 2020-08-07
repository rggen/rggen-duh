# frozen_string_literal: true

RSpec.describe 'extractor/initial_value' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:bit_field, :initial_value)
  end

  let(:duh) do
    <<~'DUH'
      {
        component: {
          memoryMaps: [{
            addressBlocks: [{
              usage: 'register',
              registers: [{
                fields: [
                  { resetValue: 0 },
                  { resetValue: 1 },
                  {}
                ]
              }]
            }]
          }]
        }
      }
    DUH
  end

  it '\'resetValue\'を取り出して、bit_field階層の\'initial_value\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(bit_fields[0]).to have_value(:initial_value, 0)
    expect(bit_fields[1]).to have_value(:initial_value, 1)
    expect(bit_fields[2]).not_to have_value(:initial_value)
  end
end
