# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleEntry < BMFF::Box::Base
  attr_accessor :reserved1, :data_reference_index

  def parse_data
    super
    @reserved1 = []
    6.times do
      @reserved1 << io.get_uint8
    end
    @data_reference_index = io.get_uint16
  end
end
