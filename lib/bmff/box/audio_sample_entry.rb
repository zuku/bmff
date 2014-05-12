# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::AudioSampleEntry < BMFF::Box::SampleEntry
  attr_accessor :reserved2, :channelcount, :samplesize, :pre_defined, :reserved3, :samplerate

  def parse_data
    super
    @reserved2 = [io.get_uint32, io.get_uint32]
    @channelcount = io.get_uint16
    @samplesize = io.get_uint16
    @pre_defined = io.get_uint16
    @reserved3 = io.get_uint16
    @samplerate = io.get_uint32
  end
end
