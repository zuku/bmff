# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TimeToSample < BMFF::Box::Full
  attr_accessor :entry_count, :sample_count, :sample_delta
  register_box "stts"

  def parse_data
    super
    @entry_count = io.get_uint32
    @sample_count = []
    @sample_delta = []
    @entry_count.times do
      @sample_count << io.get_uint32
      @sample_delta << io.get_uint32
    end
  end
end
