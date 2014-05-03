# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleAuxiliaryInformationSizes < BMFF::Box::Full
  attr_accessor :aux_info_type, :aux_info_type_parameter, :default_sample_info_size, :sample_count, :sample_info_size
  register_box "saiz"

  def parse_data
    super
    if flags & 1 > 0
      @aux_info_type = io.get_uint32
      @aux_info_type_parameter = io.get_uint32
    end
    @default_sample_info_size = io.get_uint8
    @sample_count = io.get_uint32
    if @default_sample_info_size == 0
      @sample_info_size = []
      @sample_count.times do
        @sample_info_size << io.get_uint8
      end
    end
  end
end
