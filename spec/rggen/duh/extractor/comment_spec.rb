# frozen_string_literal: true

RSpec.describe 'extractor/comment' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:register, :comment)
    RgGen.enable(:bit_field, :comment)
  end

  let(:duh) do
    <<~'DUH'
      {
        component: {
          memoryMaps: [{
            addressBlocks: [{
              name: 'foo',
              usage: 'register',
              registers: [{
                description: 'this is foo.',
                fields: [{
                  description: 'this is bar.'
                }]
              },{
                description: 'this is baz.',
                fields: [{
                  description: 'this is qux.'
                }]
              },{
                fields: [{
                }]
              }]
            }]
          }]
        }
      }
    DUH
  end

  it '\'description\'を取り出して、register/bit_field階層の\'comment\'とする' do
    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    expect(registers[0]).to have_value(:comment, 'this is foo.')
    expect(registers[1]).to have_value(:comment, 'this is baz.')
    expect(registers[2]).not_to have_value(:comment)

    expect(bit_fields[0]).to have_value(:comment, 'this is bar.')
    expect(bit_fields[1]).to have_value(:comment, 'this is qux.')
    expect(bit_fields[2]).not_to have_value(:comment)
  end
end
