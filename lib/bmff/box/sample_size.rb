# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleSize < BMFF::Box::Full
  attr_accessor :sample_size, :sample_count, :entry_size
  register_box "stsz"

  def parse_data
    super
    @sample_size = io.get_uint32
    @sample_count = io.get_uint32
    @entry_size = []
    if @sample_size == 0
      @sample_count.times do
        @entry_size << io.get_uint32
      end
    end
  end
end
