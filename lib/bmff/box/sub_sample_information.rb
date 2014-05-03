# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SubSampleInformation < BMFF::Box::Full
  attr_accessor :sample_count, :sample_delta, :subsample_count, :subsample_size,
                :subsample_priority, :discardable, :reserved1
  register_box "subs"

  def parse_data
    super
    @entry_count = io.get_uint32
    @sample_delta = []
    @subsample_count = []
    @subsample_size = []
    @subsample_priority = []
    @discardable = []
    @reserved1 = []
    @entry_count.times do
      @sample_delta << io.get_uint32
      @subsample_count << io.get_uint16
      @subsample_count.last.times do
        if version == 1
          @subsample_size << io.get_uint32
        else
          @subsample_size << io.get_uint16
        end
        @subsample_priority << io.get_uint8
        @discardable << io.get_uint8
        @reserved1 << io.get_uint32
      end
    end
  end
end
