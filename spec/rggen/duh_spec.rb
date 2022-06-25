# frozen_string_literal: true

RSpec.describe RgGen::DUH do
  describe 'DUHファイルの読み込み' do
    include_context 'clean-up builder'
    include_context 'configuration common'
    include_context 'duh common'

    before(:all) do
      RgGen.enable_all
    end

    let(:configuration) do
      file = File.join(RGGEN_SAMPLE_DIRECTORY, 'config.yml')
      build_configuration_factory(RgGen.builder, false).create([file])
    end

    let(:duh_file) do
      File.join(RGGEN_DUH_ROOT, 'spec', 'fixtures', 'sample.json5')
    end

    it 'DUHファイルを読み込んで、レジスタマップに展開する' do
      register_map = factory.create(configuration, [duh_file])

      register_block = register_map.register_blocks[0]
      expect(register_block).to have_property(:name, 'csrAddressBlock')
      expect(register_block).to have_property(:byte_size, 1024)

      register = register_block.registers[0]
      expect(register).to have_property(:name, 'ODATA')
      expect(register).to have_property(:offset_address, 0x00)
      expect(register).to have_property(:comment, 'This drives the output data pins.')

      bit_field = register.bit_fields[0]
      expect(bit_field).to have_property(:name, 'data')
      expect(bit_field).to have_property(:lsb, 0)
      expect(bit_field).to have_property(:width, 32)
      expect(bit_field).to have_property(:type, :rw)
      expect(bit_field).to have_property(:initial_value, 0)

      register = register_block.registers[1]
      expect(register).to have_property(:name, 'OENABLE')
      expect(register).to have_property(:offset_address, 0x04)
      expect(register).to have_property(:comment, 'This determines whether the pin is an input or an output. If the data direction bit is a 1, then the pin is an input.')

      bit_field = register.bit_fields[0]
      expect(bit_field).to have_property(:name, 'data')
      expect(bit_field).to have_property(:lsb, 0)
      expect(bit_field).to have_property(:width, 32)
      expect(bit_field).to have_property(:type, :rw)
      expect(bit_field).to have_property(:initial_value, 0)

      register = register_block.registers[2]
      expect(register).to have_property(:name, 'IDATA')
      expect(register).to have_property(:offset_address, 0x08)
      expect(register).to have_property(:comment, 'This is driven by the input data pins.')

      bit_field = register.bit_fields[0]
      expect(bit_field).to have_property(:name, 'data')
      expect(bit_field).to have_property(:lsb, 0)
      expect(bit_field).to have_property(:width, 32)
      expect(bit_field).to have_property(:type, :ro)
    end
  end
end
