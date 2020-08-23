# frozen_string_literal: true

RgGen.define_value_extractor(:register_map, :duh, :bit_field, :type) do
  extract { |duh| find_type(duh) }

  private

  TYPE_MAP = {
    rw: {
      access: 'read-write', modified_write_value: 'default',
      read_action: 'default', reserved: false
    },
    ro: {
      access: 'read-only', read_action: 'default', reserved: false
    },
    wo: {
      access: 'write-only', modified_write_value: 'default', reserved: false
    },
    wrc: {
      access: 'read-write', modified_write_value: 'default',
      read_action: 'clear', reserved: false
    },
    wrs: {
      access: 'read-write', modified_write_value: 'default',
      read_action: 'set', reserved: false
    },
    rc: {
      access: 'read-only', read_action: 'clear', reserved: false
    },
    w0c: {
      access: 'read-write', modified_write_value: 'zeroToClear',
      read_action: 'default', reserved: false
    },
    w1c: {
      access: 'read-write', modified_write_value: 'oneToClear',
      read_action: 'default', reserved: false
    },
    wc: {
      access: 'read-write', modified_write_value: 'clear',
      read_action: 'default', reserved: false
    },
    woc: {
      access: 'write-only', modified_write_value: 'clear', reserved: false
    },
    rs: {
      access: 'read-only', read_action: 'set', reserved: false
    },
    w0s: {
      access: 'read-write', modified_write_value: 'zeroToSet',
      read_action: 'default', reserved: false
    },
    w1s: {
      access: 'read-write', modified_write_value: 'oneToSet',
      read_action: 'default', reserved: false
    },
    ws: {
      access: 'read-write', modified_write_value: 'set',
      read_action: 'default', reserved: false
    },
    wos: {
      access: 'write-only', modified_write_value: 'set', reserved: false
    },
    w0t: {
      access: 'read-write', modified_write_value: 'zeroToToggle',
      read_action: 'default', reserved: false
    },
    w1t: {
      access: 'read-write', modified_write_value: 'oneToToggle',
      read_action: 'default', reserved: false
    },
    w0crs: {
      access: 'read-write', modified_write_value: 'zeroToClear',
      read_action: 'set', reserved: false
    },
    w1crs: {
      access: 'read-write', modified_write_value: 'oneToClear',
      read_action: 'set', reserved: false
    },
    wcrs: {
      access: 'read-write', modified_write_value: 'clear',
      read_action: 'set', reserved: false
    },
    w0src: {
      access: 'read-write', modified_write_value: 'zeroToSet',
      read_action: 'clear', reserved: false
    },
    w1src: {
      access: 'read-write', modified_write_value: 'oneToSet',
      read_action: 'clear', reserved: false
    },
    wsrc: {
      access: 'read-write', modified_write_value: 'set',
      read_action: 'clear', reserved: false
    },
    w1: {
      access: 'read-writeOnce', modified_write_value: 'default',
      read_action: 'default', reserved: false
    },
    wo1: {
      access: 'writeOnce', modified_write_value: 'default', reserved: false
    },
    reserved: {
      reserved: true
    }
  }.freeze

  def find_type(duh)
    TYPE_MAP.find { |_, properties| match_properties?(duh, properties) }&.first
  end

  def match_properties?(duh, properties)
    properties.all? { |name, value| __send__(name, duh) == value }
  end

  def access(duh)
    if duh.key?('access')
      duh['access']
    elsif duh.layer == :register_block
      'read-write'
    else
      access(duh.parent)
    end
  end

  def modified_write_value(duh)
    duh.fetch('modifiedWriteValue', 'default')
  end

  def read_action(duh)
    duh.fetch('readAction', 'default')
  end

  def reserved(duh)
    duh.fetch('reserved', false)
  end
end
