# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ColourInformation < BMFF::Box::Base
  attr_accessor :colour_type,
                :colour_primaries, :transfer_characteristics, :matrix_coefficients, :full_range_flag, :reserved1,
                :icc_profile
  register_box "colr"

  def parse_data
    super
    @colour_type = io.get_ascii(4)
    case @colour_type
    when "nclx"
      @colour_primaries = io.get_uint16
      @transfer_characteristics = io.get_uint16
      @matrix_coefficients = io.get_uint16
      tmp = io.get_uint8
      @full_range_flag = (tmp & 0x80) > 0
      @reserved1 = tmp & 0x7F
    when "rICC"
      @icc_profile = :restricted
    when "prof"
      @icc_profile = :unrestricted
    end
  end
end
