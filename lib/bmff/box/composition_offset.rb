# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::CompositionOffset < BMFF::Box::Full
  attr_accessor :entry_count, :sample_count, :sample_offset
  register_box "ctts"

  def parse_data
    super
    @entry_count = io.get_uint32
    @sample_count = []
    @sample_offset = []
    if version == 0
      @entry_count.times do
        @sample_count << io.get_uint32
        @sample_offset << io.get_uint32
      end
    elsif version == 1
      @entry_count.times do
        @sample_count << io.get_uint32
        @sample_offset << io.get_int32
      end
    end
  end
end
