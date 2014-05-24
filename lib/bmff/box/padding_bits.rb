# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::PaddingBits < BMFF::Box::Full
  attr_accessor :sample_count, :reserved1, :pad1, :reserved2, :pad2
  register_box "padb"

  def parse_data
    super
    @sample_count = io.get_uint32
    @reserved1 = []
    @pad1 = []
    @reserved2 = []
    @pad2 = []
    ((@sample_count + 1) / 2).times do
      tmp = io.get_uint8
      @reserved1 << ((tmp & 0x80) > 0)
      @pad1 << ((tmp >> 4) & 0x07)
      @reserved2 << ((tmp & 0x08) > 0)
      @pad2 << (tmp & 0x07)
    end
  end
end
