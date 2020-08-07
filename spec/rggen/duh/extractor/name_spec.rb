# frozen_string_literal: true

RSpec.describe 'extractor/name' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:register_block, :name)
    RgGen.enable(:register_file, :name)
    RgGen.enable(:register, :name)
    RgGen.enable(:bit_field, :name)
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
                name: 'bar',
                registers: [{
                  name: 'baz',
                  fields: [{
                    name: 'qux'
                  }]
                }]
              }]
            }]
          }]
        }
      }
    DUH
  end

  it '\'name\'を取り出して、各階層の\'name\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(register_blocks[0]).to have_value(:name, 'foo')
    expect(register_files[0]).to have_value(:name, 'bar')
    expect(registers[0]).to have_value(:name, 'baz')
    expect(bit_fields[0]).to have_value(:name, 'qux')
  end
end
