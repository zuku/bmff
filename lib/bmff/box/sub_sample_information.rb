# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SubSampleInformation < BMFF::Box::Full
  attr_accessor :entry_count, :sample_delta, :subsample_count, :subsamples
  register_box "subs"

  class SubSample
    attr_accessor :subsample_size, :subsample_priority, :discardable, :reserved1
    def initialize
      @subsample_size = []
      @subsample_priority = []
      @discardable = []
      @reserved1 = []
    end
  end

  def parse_data
    super
    @entry_count = io.get_uint32
    @sample_delta = []
    @subsample_count = []
    @subsamples = []
    @entry_count.times do
      @sample_delta << io.get_uint32
      @subsample_count << io.get_uint16
      subsample = SubSample.new
      @subsample_count.last.times do
        if version == 1
          subsample.subsample_size << io.get_uint32
        else
          subsample.subsample_size << io.get_uint16
        end
        subsample.subsample_priority << io.get_uint8
        subsample.discardable << io.get_uint8
        subsample.reserved1 << io.get_uint32
      end
      @subsamples << subsample
    end
  end
end
