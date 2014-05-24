# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::EditList < BMFF::Box::Full
  attr_accessor :entry_count, :segment_duration, :media_time, :media_rate_integer, :media_rate_fraction
  register_box "elst"

  def parse_data
    super
    @entry_count = io.get_uint32
    @segment_duration = []
    @media_time = []
    @media_rate_integer = []
    @media_rate_fraction = []
    @entry_count.times do
      if version == 1
        @segment_duration << io.get_uint64
        @media_time << io.get_int64
      else
        @segment_duration << io.get_uint32
        @media_time << io.get_int32
      end
      @media_rate_integer << io.get_int16
      @media_rate_fraction << io.get_int16
    end
  end
end
