# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SubsegmentIndex < BMFF::Box::Full
  attr_accessor :subsegment_count, :range_count, :ranges
  register_box "ssix"

  class Range
    attr_accessor :level, :range_size
  end

  def parse_data
    super
    @subsegment_count = io.get_uint32
    @range_count = []
    @ranges = []
    @subsegment_count.times do
      tmp = io.get_uint32
      @range_count << tmp
      range = Range.new
      range.level = []
      range.range_size = []
      tmp.times do
        range.level << io.get_uint8
        range.range_size << io.get_uint24
      end
      @ranges << range
    end
  end
end
