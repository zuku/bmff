# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SyncSample < BMFF::Box::Full
  attr_accessor :entry_count, :sample_number
  register_box "stss"

  def parse_data
    super
    @entry_count = io.get_uint32
    @sample_number = []
    @entry_count.times do
      @sample_number << io.get_uint32
    end
  end
end
