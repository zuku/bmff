# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Handler < BMFF::Box::Full
  attr_accessor :pre_defined, :handler_type, :reserved1, :name
  register_box "hdlr"

  def parse_data
    super
    @pre_defined = io.get_uint32
    @handler_type = io.get_ascii(4)
    @reserved1 = [io.get_uint32, io.get_uint32, io.get_uint32]
    @name = io.get_null_terminated_string(remaining_size) unless eob?
  end
end
