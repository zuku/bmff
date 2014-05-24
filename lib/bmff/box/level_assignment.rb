# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::LevelAssignment < BMFF::Box::Full
  attr_accessor :level_count, :levels
  register_box "leva"

  class Level
    attr_accessor :track_id, :padding_flag, :assignment_type,
                  :grouping_type, :grouping_type_parameter, :sub_track_id
  end

  def parse_data
    super
    @level_count = io.get_uint8
    @levels = []
    @level_count.times do
      level = Level.new
      level.track_id = io.get_uint32
      tmp = io.get_uint8
      level.padding_flag = (tmp >> 7)
      level.assignment_type = (tmp & 0x7F)
      case level.assignment_type
      when 0
        level.grouping_type = io.get_uint32
      when 1
        level.grouping_type = io.get_uint32
        level.grouping_type_parameter = io.get_uint32
      when 4
        level.sub_track_id = io.get_uint32
      end
      @levels << level
    end
  end
end
