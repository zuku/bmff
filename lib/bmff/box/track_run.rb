# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackRun < BMFF::Box::Full
  attr_accessor :sample_count, :data_offset, :first_sample_flags,
                :sample_duration, :sample_size, :sample_flags, :sample_composition_time_offset
  register_box "trun"

  def parse_data
    super
    @sample_count = io.get_uint32
    @data_offset = io.get_int32 if flags & 0x01 > 0
    @first_sample_flags = io.get_uint32 if flags & 0x04 > 0
    @sample_duration = [] if flags & 0x0100 > 0
    @sample_size = [] if flags & 0x0200 > 0
    @sample_flags = [] if flags & 0x0400 > 0
    @sample_composition_time_offset = [] if flags & 0x0800 > 0
    @sample_count.times do
      @sample_duration << io.get_uint32 if flags & 0x0100 > 0
      @sample_size << io.get_uint32 if flags & 0x0200 > 0
      @sample_flags << io.get_uint32 if flags & 0x0400 > 0
      if flags & 0x0800 > 0
        if version == 0
          @sample_composition_time_offset << io.get_uint32
        else
          @sample_composition_time_offset << io.get_int32
        end
      end
    end
  end
end
