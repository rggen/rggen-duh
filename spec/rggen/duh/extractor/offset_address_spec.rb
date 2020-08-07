# frozen_string_literal: true

RSpec.describe 'extractor/offset_address' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:register_file, :offset_address)
    RgGen.enable(:register, :offset_address)
  end

  let(:duh) do
    <<~'DUH'
      {
        component: {
          memoryMaps: [{
            addressBlocks: [{
              name: 'foo',
              usage: 'register',
              registerFiles: [{
                addressOffset: 0x00,
                registers: [{
                  addressOffset: 0x00
                },
                {
                  addressOffset: 0x04
                }]
              },
              {
                addressOffset: 0x10,
                registers: [{
                  addressOffset: 0x08
                },
                {
                  addressOffset: 0x0C
                }]
              }]
            }]
          }]
        }
      }
    DUH
  end

  it '\'addressOffset\'を取り出して、register_file/register階層の\'offset_address\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(register_files[0]).to have_value(:offset_address, 0x00)
    expect(register_files[1]).to have_value(:offset_address, 0x10)

    expect(registers[0]).to have_value(:offset_address, 0x00)
    expect(registers[1]).to have_value(:offset_address, 0x04)
    expect(registers[2]).to have_value(:offset_address, 0x08)
    expect(registers[3]).to have_value(:offset_address, 0x0C)
  end
end
