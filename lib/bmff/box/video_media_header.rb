# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::VideoMediaHeader < BMFF::Box::Full
  attr_accessor :graphicsmode, :opcolor
  register_box "vmhd"

  def parse_data
    super
    @graphicsmode = io.get_uint16
    @opcolor = [io.get_uint16, io.get_uint16, io.get_uint16]
  end
end
