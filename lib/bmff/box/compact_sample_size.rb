# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::CompactSampleSize < BMFF::Box::Full
  attr_accessor :reserved1, :field_size, :sample_count, :entry_size
  register_box "stz2"

  def parse_data
    super
    @reserved1 = io.get_uint24
    @field_size = io.get_uint8
    @sample_count = io.get_uint32
    @entry_size = []
    i = 0
    while i < @sample_count
      case @field_size
      when 4
        tmp = io.get_uint8
        @entry_size << (tmp >> 4)
        i += 1
        @entry_size << (tmp & 0x0F) if i < @sample_count
      when 8
        @entry_size << io.get_uint8
      when 16
        @entry_size << io.get_uint16
      else
        raise ArgumentError, "Unsupported field_size"
      end
      i += 1
    end
  end
end
