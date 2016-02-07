# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SegmentIndex < BMFF::Box::Full
  attr_accessor :reference_id, :timescale, :earliest_presentation_time,
                :first_offset, :reserved1, :reference_count,
                :reference_type, :referenced_size,
                :subsegment_duration,
                :start_with_sap, :sap_type, :sap_delta_time
  register_box "sidx"

  def parse_data
    super
    @reference_id = io.get_uint32
    @timescale = io.get_uint32
    if version == 0
      @earliest_presentation_time = io.get_uint32
      @first_offset = io.get_uint32
    else
      @earliest_presentation_time = io.get_uint64
      @first_offset = io.get_uint64
    end
    @reserved1 = io.get_uint16
    @reference_count = io.get_uint16
    @reference_type = []
    @referenced_size = []
    @subsegment_duration = []
    @start_with_sap = []
    @sap_type = []
    @sap_delta_time = []
    @reference_count.times do
      tmp = io.get_uint32
      @reference_type << ((tmp & 0x80000000) > 0)
      @referenced_size << (tmp & 0x7FFFFFFF)
      @subsegment_duration << io.get_uint32
      tmp = io.get_uint32
      @start_with_sap << ((tmp & 0x80000000) > 0)
      @sap_type << ((tmp >> 28) & 0x07)
      @sap_delta_time << (tmp & 0x0FFFFFFF)
    end
  end
end
