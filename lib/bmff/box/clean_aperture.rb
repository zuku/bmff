# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::CleanAperture < BMFF::Box::Base
  attr_accessor :clean_aperture_width_n, :clean_aperture_width_d, :clean_aperture_height_n, :clean_aperture_height_d,
                :horiz_off_n, :horiz_off_d, :vert_off_n, :vert_off_d
  register_box "clap"

  def parse_data
    super
    @clean_aperture_width_n = io.get_uint32
    @clean_aperture_width_d = io.get_uint32
    @clean_aperture_height_n = io.get_uint32
    @clean_aperture_height_d = io.get_uint32
    @horiz_off_n = io.get_uint32
    @horiz_off_d = io.get_uint32
    @vert_off_n = io.get_uint32
    @vert_off_d = io.get_uint32
  end
end
