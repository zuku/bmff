# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::HintMediaHeader < BMFF::Box::Full
  attr_accessor :max_pdu_size, :avg_pdu_size, :maxbitrate, :avgbitrate, :reserved1
  register_box "hmhd"

  def parse_data
    super
    @max_pdu_size = io.get_uint16
    @avg_pdu_size = io.get_uint16
    @maxbitrate = io.get_uint32
    @avgbitrate = io.get_uint32
    @reserved1 = io.get_uint32
  end
end
