# frozen_string_literal: true

RSpec.describe 'extractor/bit_assignment' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:bit_field, :bit_assignment)
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
                  { bitOffset:  0, bitWidth: 1 },
                  { bitOffset:  1, bitWidth: 2 },
                  { bitOffset: 16, bitWidth: 8 }
                ]
              }]
            }]
          }]
        }
      }
    DUH
  end

  it '\'bitOffset\'/\'bitWidth\'を取り出して、bit_field階層の\'bit_assignment\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(bit_fields[0]).to have_value(:bit_assignment, { lsb:  0, width: 1 })
    expect(bit_fields[1]).to have_value(:bit_assignment, { lsb:  1, width: 2 })
    expect(bit_fields[2]).to have_value(:bit_assignment, { lsb: 16, width: 8 })
  end
end
