# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::XMLMetaDataSampleEntry < BMFF::Box::MetaDataSampleEntry
  attr_accessor :content_encoding, :namespace, :schema_location, :bit_rate_box
  register_box "metx"
  include(BMFF::Box::Container)

  def parse_data
    super
    @content_encoding = io.get_null_terminated_string unless eob?
    @namespace = io.get_null_terminated_string unless eob?
    @schema_location = io.get_null_terminated_string unless eob?
    unless eob?
      @bit_rate_box = BMFF::Box.get_box(io, self, BMFF::Box::BitRate)
      add_child @bit_rate_box
    end
  end
end
