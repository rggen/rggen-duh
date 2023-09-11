# frozen_string_literal: true

RSpec.shared_context 'duh common' do
  def setup_duh_file(contents)
    io = StringIO.new(+contents)
    allow(File).to receive(:open).with(file_name, 'r').and_yield(io)
    allow(File).to receive(:readable?).with(file_name).and_return(true)
  end

  def collect_target_data(input_data, layer)
    [
      *(input_data.layer == layer && input_data || nil),
      *input_data.children.flat_map { |child| collect_target_data(child, layer) }
    ]
  end

  let(:factory) do
    RgGen.builder.build_factory(:input, :register_map)
  end

  let(:valid_value_lists) do
    factory.__send__(:valid_value_lists)
  end

  let(:input_data) do
    factory.__send__(:create_input_data, nil)
  end

  let(:loader) do
    l = factory.loaders.find { |loader| loader.support?(file_name) }
    l.disable_validation
    l
  end

  let(:file_name) do
    'test.json5'
  end

  let(:register_blocks) do
    collect_target_data(input_data, :register_block)
  end

  let(:register_files) do
    collect_target_data(input_data, :register_file)
  end

  let(:registers) do
    collect_target_data(input_data, :register)
  end

  let(:bit_fields) do
    collect_target_data(input_data, :bit_field)
  end
end
