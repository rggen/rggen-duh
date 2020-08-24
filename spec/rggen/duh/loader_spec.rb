# frozen_string_literal: true

RSpec.describe RgGen::DUH::Loader do
  include_context 'duh common'

  let(:loader) { described_class.new(extractors, {}) }

  let(:extractors) do
    [
      create_extracter([:register_block, :register_file, :register, :bit_field], :name) { |v| v['name'] },
      create_extracter([:register_block], :baseAddress) { |v| v['baseAddress'] },
      create_extracter([:register_file, :register], :addressOffset) { |v| v['addressOffset'] },
      create_extracter([:bit_field], :bitOffset) { |v| v['bitOffset'] }
    ]
  end

  let(:valid_value_lists) do
    {
      root: [],
      register_block: [:name, :baseAddress],
      register_file: [:name, :addressOffset],
      register: [:name, :addressOffset],
      bit_field: [:name, :bitOffset]
    }
  end

  let(:input_data) do
    RgGen::Core::RegisterMap::InputData.new(:root, valid_value_lists)
  end

  def create_extracter(target_layers, target_value, &body)
    Class
      .new(RgGen::Core::InputBase::InputValueExtractor) { extract(&body) }
      .new(target_layers, target_value)
  end

  it 'json5形式に対応する' do
    expect(loader.support?('foo.json5')).to be true
    expect(loader.support?('foo.json')).to be false
    expect(loader.support?('foo.yaml')).to be false
    expect(loader.support?('foo.xlsx')).to be false
  end

  describe '#load_file' do
    let(:duh) do
      <<~'DUH'
        {
          component: {
            vendor: 'foo',
            library: 'blocks',
            name: 'test',
            version: '0.0.0',
            memoryMaps:[{
              name: 'CSR',
              addressBlocks: [{
                name: 'CSR0',
                baseAddress: 0,
                range: 1024,
                width: 32,
                usage: 'register',
                registers: [{
                  name: 'ODATA',
                  addressOffset: 0,
                  size: 32,
                  fields: [{
                    name: 'odata', bitOffset: 0, bitWidth: 8
                  }, {
                    name: 'omask', bitOffset: 8, bitWidth: 8
                  }]
                }],
                registerFiles: [{
                  name: 'registerFile_0',
                  addressOffset: 4,
                  range: 8,
                  registers: [{
                    name: 'IDATA',
                    addressOffset: 4,
                    size: 32,
                    fields: [{
                      name: 'idata', bitOffset: 8, bitWidth: 8
                    }, {
                      name: 'imask', bitOffset: 0, bitWidth: 8
                    }]
                  }]
                }]
              }]
            }]
          }
        }
      DUH
    end

    let(:duh_with_json_ref) do
      <<~'DUH'
        {
          definitions: {
            csrMemMap: {
              name: 'CSR',
              addressBlocks: [{
                name: 'CSR0',
                baseAddress: 0,
                range: 1024,
                width: 32,
                usage: 'register',
                registers: [{
                  name: 'ODATA',
                  addressOffset: 0,
                  size: 32,
                  fields: [{
                    name: 'odata', bitOffset: 0, bitWidth: 8
                  }, {
                    name: 'omask', bitOffset: 8, bitWidth: 8
                  }]
                }],
                registerFiles: [{
                  name: 'registerFile_0',
                  addressOffset: 4,
                  range: 8,
                  registers: [{
                    name: 'IDATA',
                    addressOffset: 4,
                    size: 32,
                    fields: [{
                      name: 'idata', bitOffset: 8, bitWidth: 8
                    }, {
                      name: 'imask', bitOffset: 0, bitWidth: 8
                    }]
                  }]
                }]
              }]
            }
          },
          component: {
            vendor: 'foo',
            library: 'blocks',
            name: 'test',
            version: '0.0.0',
            memoryMaps: [{$ref: '#/definitions/csrMemMap'}]
          }
        }
      DUH
    end

    it '入力したDUHファイルをもとに、入力データを組み立てる' do
      setup_duh_file(duh)
      loader.load_file(file_name, input_data, valid_value_lists)

      expect(register_blocks[0])
        .to have_value(:name, 'CSR0').and have_value(:baseAddress, 0)
      expect(register_files[0])
        .to have_value(:name, 'registerFile_0').and have_value(:addressOffset, 4)
      expect(registers[0])
        .to have_value(:name, 'IDATA').and have_value(:addressOffset, 4)
      expect(registers[1])
        .to have_value(:name, 'ODATA').and have_value(:addressOffset, 0)
      expect(bit_fields[0])
        .to have_value(:name, 'idata').and have_value(:bitOffset, 8)
      expect(bit_fields[1])
        .to have_value(:name, 'imask').and have_value(:bitOffset, 0)
      expect(bit_fields[2])
        .to have_value(:name, 'odata').and have_value(:bitOffset, 0)
      expect(bit_fields[3])
        .to have_value(:name, 'omask').and have_value(:bitOffset, 8)
    end

    it 'JSON Referenceに対応する' do
      setup_duh_file(duh_with_json_ref)
      loader.load_file(file_name, input_data, valid_value_lists)

      expect(register_blocks[0])
        .to have_value(:name, 'CSR0').and have_value(:baseAddress, 0)
      expect(register_files[0])
        .to have_value(:name, 'registerFile_0').and have_value(:addressOffset, 4)
      expect(registers[0])
        .to have_value(:name, 'IDATA').and have_value(:addressOffset, 4)
      expect(registers[1])
        .to have_value(:name, 'ODATA').and have_value(:addressOffset, 0)
      expect(bit_fields[0])
        .to have_value(:name, 'idata').and have_value(:bitOffset, 8)
      expect(bit_fields[1])
        .to have_value(:name, 'imask').and have_value(:bitOffset, 0)
      expect(bit_fields[2])
        .to have_value(:name, 'odata').and have_value(:bitOffset, 0)
      expect(bit_fields[3])
        .to have_value(:name, 'omask').and have_value(:bitOffset, 8)
    end

    context '文法エラーを含むDUHファイルが入力された場合' do
      let(:duh_with_syntax_error) do
        <<~'DUH'
          { foo bar }
        DUH
      end

      before do
        setup_duh_file(duh_with_syntax_error)
      end

      it 'ParseErrorを発生させる' do
        expect {
          loader.load_file(file_name, input_data, valid_value_lists)
        }.to raise_error RgGen::DUH::ParseError, <<~MESSAGE.strip
          Failed to match sequence (SPACE? VALUE SPACE?) at line 1 char 1. -- #{file_name}
        MESSAGE
      end

      specify '詳細が#verbose_infoに設定される' do
        begin
          loader.load_file(file_name, input_data, valid_value_lists)
        rescue RgGen::DUH::ParseError => e
          expect(e.verbose_info).to eq <<~INFO.strip
            Failed to match sequence (SPACE? VALUE SPACE?) at line 1 char 1.
            `- Expected ":", but got "b" at line 1 char 7.
          INFO
        end
      end
    end

    context '不正なDUHファイルが入力された場合' do
      let(:invalid_duh) do
        <<~'DUH'
          {
            component: {}
          }
        DUH
      end

      it 'ValidationFailedを発生させる' do
        setup_duh_file(invalid_duh)
        expect {
          loader.load_file(file_name, input_data, valid_value_lists)
        }.to raise_error RgGen::DUH::ValidationFailed, <<~MESSAGE.strip
          input DUH file is invalid: #{file_name}
            - property '/component' is missing required keys: vendor, library, name, version
        MESSAGE
      end
    end
  end
end
