# frozen_string_literal: true

RSpec.shared_context 'duh common' do
  def setup_duh_file(file_name, contents)
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

  let(:input_data) do
    RgGen::Core::RegisterMap::InputData.new(:root, valid_value_lists)
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
