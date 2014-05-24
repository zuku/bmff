# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MovieFragmentRandomAccessOffset < BMFF::Box::Full
  attr_accessor :mfra_size
  register_box "mfro"

  def parse_data
    super
    @mfra_size = io.get_uint32
  end
end
