# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::PixelAspectRatio < BMFF::Box::Base
  attr_accessor :h_spacing, :v_spacing
  register_box "pasp"

  def parse_data
    super
    @h_spacing = io.get_uint32
    @v_spacing = io.get_uint32
  end
end
