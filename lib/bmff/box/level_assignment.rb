# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::LevelAssignment < BMFF::Box::Full
  attr_accessor :level_count, :track_id, :padding_flag, :assignment_type,
                :grouping_type, :grouping_type_parameter, :sub_track_id
  register_box "leva"

  def parse_data
    super
    @level_count = io.get_uint8
    @track_id = []
    @padding_flag = []
    @assignment_type = []
    @grouping_type = []
    @grouping_type_parameter = []
    @sub_track_id = []
    @level_count.times do
      @track_id << io.get_uint32
      tmp = io.get_uint8
      @padding_flag << (tmp >> 7)
      @assignment_type << (tmp & 0x7F)
      case @assignment_type
      when 0
        @grouping_type << io.get_uint32
      when 1
        @grouping_type << io.get_uint32
        @grouping_type_parameter << io.get_uint32
      when 4
        @sub_track_id << io.get_uint32
      end
    end
  end
end
