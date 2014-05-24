# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ShadowSyncSample < BMFF::Box::Full
  attr_accessor :entry_count, :shadowed_sample_number, :sync_sample_number
  register_box "stsh"

  def parse_data
    super
    @entry_count = io.get_uint32
    @shadowed_sample_number = []
    @sync_sample_number = []
    @entry_count.times do
      @shadowed_sample_number << io.get_uint32
      @sync_sample_number << io.get_uint32
    end
  end
end
