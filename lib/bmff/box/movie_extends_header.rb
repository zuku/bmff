# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MovieExtendsHeader < BMFF::Box::Full
  attr_accessor :fragment_duration
  register_box "mehd"

  def parse_data
    super
    if version == 1
      @fragment_duration = io.get_uint64
    else
      @fragment_duration = io.get_uint32
    end
  end
end
