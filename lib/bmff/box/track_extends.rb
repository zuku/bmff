# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackExtends < BMFF::Box::Full
  attr_accessor :track_id, :default_sample_description_index, :default_sample_duration,
                :default_sample_size, :default_sample_flags
  register_box "trex"

  def parse_data
    super
    @track_id = io.get_uint32
    @default_sample_description_index = io.get_uint32
    @default_sample_duration = io.get_uint32
    @default_sample_size = io.get_uint32
    @default_sample_flags = io.get_uint32
  end
end
