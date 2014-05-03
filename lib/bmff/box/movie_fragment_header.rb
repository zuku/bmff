# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MovieFragmentHeader < BMFF::Box::Full
  attr_accessor :sequence_number
  register_box "mfhd"

  def parse_data
    super
    @sequence_number = io.get_uint32
  end
end
