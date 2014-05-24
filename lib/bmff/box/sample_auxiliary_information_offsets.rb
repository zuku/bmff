# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleAuxiliaryInformationOffsets < BMFF::Box::Full
  attr_accessor :aux_info_type, :aux_info_type_parameter, :entry_count, :offsets
  register_box "saio"

  def parse_data
    super
    if flags & 1 > 0
      @aux_info_type = io.get_uint32
      @aux_info_type_parameter = io.get_uint32
    end
    @entry_count = io.get_uint32
    @offsets = []
    @entry_count.times do
      if version == 0
        @offsets << io.get_uint32
      else
        @offsets << io.get_uint64
      end
    end
  end
end
