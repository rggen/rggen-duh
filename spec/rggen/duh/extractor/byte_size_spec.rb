# frozen_string_literal: true

RSpec.describe 'extractor/byte_size' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:register_block, :byte_size)
  end

  let(:duh) do
    <<~'DUH'
      {
        component: {
          memoryMaps: [{
            addressBlocks: [{
              range: 512,
              usage: 'register'
            },{
              range: 256,
              usage: 'register'
            }]
          }]
        }
      }
    DUH
  end

  it '\'range\'を取り出して、register_block階層の\'byte_size\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(register_blocks[0]).to have_value(:byte_size, 512)
    expect(register_blocks[1]).to have_value(:byte_size, 256)
  end
end
