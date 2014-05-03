# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TextMetaDataSampleEntry < BMFF::Box::MetaDataSampleEntry
  attr_accessor :content_encoding, :mime_format, :bit_rate_box
  register_box "mett"
  include(BMFF::Box::Container)

  def parse_data
    super
    @content_encoding = io.get_null_terminated_string
    @mime_format = io.get_null_terminated_string
    unless eob?
      @bit_rate_box = BMFF::Box.get_box(io, self, BMFF::Box.BitRate)
      add_child @bit_rate_box
    end
  end
end
