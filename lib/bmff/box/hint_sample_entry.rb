# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::HintSampleEntry < BMFF::Box::SampleEntry
  attr_accessor :data

  def parse_data
    super
    @data = []
    until eob?
      @data << io.get_uint8
    end
  end
end
