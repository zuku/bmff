# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::PixelAspectRatio < BMFF::Box::Base
  attr_accessor :hspacing, :vspacing
  register_box "pasp"

  def parse_data
    super
    @hspacing = io.get_uint32
    @vspacing = io.get_uint32
  end
end
