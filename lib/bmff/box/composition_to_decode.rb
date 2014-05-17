# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::CompositionToDecode < BMFF::Box::Full
  attr_accessor :composition_to_dts_shift, :least_decode_to_display_delta, :greatest_decode_to_display_delta,
                :composition_start_time, :composition_end_time
  register_box "cslg"

  def parse_data
    super
    @composition_to_dts_shift = io.get_int32
    @least_decode_to_display_delta = io.get_int32
    @greatest_decode_to_display_delta = io.get_int32
    @composition_start_time = io.get_int32
    @composition_end_time = io.get_int32
  end
end
