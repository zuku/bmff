# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SoundMediaHeader < BMFF::Box::Full
  attr_accessor :balance, :reserved1
  register_box "smhd"

  def parse_data
    super
    @balance = io.get_int16
    @reserved1 = io.get_uint16
  end
end
