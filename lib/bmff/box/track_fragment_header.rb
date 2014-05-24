# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackFragmentHeader < BMFF::Box::Full
  attr_accessor :track_id, :base_data_offset, :sample_description_index,
                :default_sample_duration, :default_sample_size, :default_sample_flags
  register_box "tfhd"

  def parse_data
    super
    @track_id = io.get_uint32
    @base_data_offset = io.get_uint64 if flags & 0x01 > 0
    @sample_description_index = io.get_uint32 if flags & 0x02 > 0
    @default_sample_duration = io.get_uint32 if flags & 0x08 > 0
    @default_sample_size = io.get_uint32 if flags & 0x10 > 0
    @default_sample_flags = io.get_uint32 if flags & 0x20 > 0
  end
end
