# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ProtectionSystemSpecificHeader < BMFF::Box::Full
  attr_accessor :system_id, :data_size, :data
  register_uuid_box "d08a4f18-10f3-4a82-b6c8-32d8aba183d3"

  def parse_data
    super
    @system_id = io.get_uuid
    @data_size = io.get_uint32
    @data = io.get_byte(@data_size)
  end
end
