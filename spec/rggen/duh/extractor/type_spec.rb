# frozen_string_literal: true

RSpec.describe 'extractor/type' do
  include_context 'clean-up builder'
  include_context 'duh common'

  before(:all) do
    RgGen.enable(:bit_field, :type)
  end

  it '\'access\'/\'modifiedWriteValue\'/\'readAction\'/\'reserved\'を取り出してbit_field階層の\'type\'とする' do
    duh = <<~'DUH'
      {
        component: {
          memoryMaps: [{
            addressBlocks: [{
              usage: 'register',
              registers: [{
                fields: [
                  { access: 'read-write' },
                  { access: 'read-only' },
                  { access: 'write-only' },
                  { access: 'read-write', readAction: 'clear' },
                  { access: 'read-write', readAction: 'set' },
                  { access: 'read-only', readAction: 'clear' },
                  { access: 'read-write', modifiedWriteValue: 'zeroToClear' },
                  { access: 'read-write', modifiedWriteValue: 'oneToClear' },
                  { access: 'read-write', modifiedWriteValue: 'clear' },
                  { access: 'write-only', modifiedWriteValue: 'clear' },
                  { access: 'read-only', readAction: 'set' },
                  { access: 'read-write', modifiedWriteValue: 'zeroToSet' },
                  { access: 'read-write', modifiedWriteValue: 'oneToSet' },
                  { access: 'read-write', modifiedWriteValue: 'set' },
                  { access: 'write-only', modifiedWriteValue: 'set' },
                  { access: 'read-write', modifiedWriteValue: 'zeroToToggle' },
                  { access: 'read-write', modifiedWriteValue: 'oneToToggle' },
                  { access: 'read-write', modifiedWriteValue: 'zeroToClear', readAction: 'set' },
                  { access: 'read-write', modifiedWriteValue: 'oneToClear', readAction: 'set' },
                  { access: 'read-write', modifiedWriteValue: 'clear', readAction: 'set' },
                  { access: 'read-write', modifiedWriteValue: 'zeroToSet', readAction: 'clear' },
                  { access: 'read-write', modifiedWriteValue: 'oneToSet', readAction: 'clear' },
                  { access: 'read-write', modifiedWriteValue: 'set', readAction: 'clear' },
                  { access: 'read-writeOnce' },
                  { access: 'writeOnce' },
                  { reserved: true }
                ]
              }]
            }]
          }]
        }
      }
    DUH

    setup_duh_file(duh)
    loader.load_file(file_name, input_data, valid_value_lists)

    [
      :rw, :ro, :wo, :wrc, :wrs, :rc, :w0c, :w1c, :wc, :woc, :rs, :w0s, :w1s, :ws, :wos,
      :w0t, :w1t, :w0crs, :w1crs, :wcrs, :w0src, :w1src, :wsrc, :w1, :wo1, :reserved
    ].each_with_index do |type, i|
      expect(bit_fields[i]).to have_value(:type, type)
    end
  end

  context '\'access\'が未指定の場合' do
    specify '上位階層の\'access\'が参照される' do
      duh = <<~'DUH'
        {
          component: {
            memoryMaps: [{
              addressBlocks: [{
                usage: 'register',
                access: 'read-only',
                registerFiles: [{
                  registers: [{
                    fields: [{}]
                  }]
                }],
                registers: [{
                  access: 'write-only',
                  fields: [{}]
                },{
                  fields: [{}]
                }]
              },{
                usage: 'register',
                registers: [{
                  fields: [{}]
                }],
                registerFiles: [{
                  registers: [{
                    fields: [{}]
                  }]
                }]
              }]
            }]
          }
        }
      DUH

      setup_duh_file(duh)
      loader.load_file(file_name, input_data, valid_value_lists)

      expect(bit_fields[0]).to have_value(:type, :ro)
      expect(bit_fields[1]).to have_value(:type, :wo)
      expect(bit_fields[2]).to have_value(:type, :ro)
      expect(bit_fields[3]).to have_value(:type, :rw)
      expect(bit_fields[4]).to have_value(:type, :rw)
    end
  end
end
