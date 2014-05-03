# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackFragmentRandomAccess < BMFF::Box::Full
  attr_accessor :track_id, :reserved1,
                :length_size_of_traf_num, :length_size_of_trun_num, :length_size_of_sample_num,
                :number_of_entry, :time, :moof_offset, :traf_number, :trun_number, :sample_number
  register_box "tfra"

  def parse_data
    super
    @track_id = io.get_uint32
    tmp = io.get_uint32
    @reserved1 = (tmp >> 6)
    @length_size_of_traf_num = (tmp >> 4) & 0x03
    @length_size_of_trun_num = (tmp >> 2) & 0x03
    @length_size_of_sample_num = (tmp & 0x03)
    @number_of_entry = io.get_uint32
    @time = []
    @moof_offset = []
    @traf_number = []
    @trun_number = []
    @sample_number = []
    @number_of_entry.times do
      if version == 1
        @time << io.get_uint64
        @moof_offset << io.get_uint64
      else
        @time << io.get_uint32
        @moof_offset << io.get_uint32
      end
      @traf_number << get_variable_size_uint((@length_size_of_traf_num + 1) * 8)
      @trun_number << get_variable_size_uint((@length_size_of_trun_num + 1) * 8)
      @sample_number << get_variable_size_uint((@length_size_of_sample_num + 1) * 8)
    end
  end

  def get_variable_size_uint(size)
    case size
    when 8
      io.get_uint8
    when 16
      io.get_uint16
    when 32
      io.get_uint32
    when 64
      io.get_uint64
    else
      raise ArgumentError, "Unsupported field size."
    end
  end

  private :get_variable_size_uint
end
