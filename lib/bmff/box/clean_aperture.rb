# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::CleanAperture < BMFF::Box::Base
  attr_accessor :cleanaperturewidthn, :cleanaperturewidthd, :cleanapertureheightn, :cleanapertureheightd,
                :horizoffn, :horizoffd, :vertoffn, :vertoffd
  register_box "clap"

  def parse_data
    super
    @cleanaperturewidthn = io.get_uint32
    @cleanaperturewidthd = io.get_uint32
    @cleanapertureheightn = io.get_uint32
    @cleanapertureheightd = io.get_uint32
    @horizoffn = io.get_uint32
    @horizoffd = io.get_uint32
    @vertoffn = io.get_uint32
    @vertoffd = io.get_uint32
  end
end
