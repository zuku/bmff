# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::URIMetaSampleEntry < BMFF::Box::MetaDataSampleEntry
  attr_accessor :uri_box, :uri_init_box, :mpeg4_bit_rate_box
  register_box "urim"
  include(BMFF::Box::Container)

  def parse_data
    super
    @uri_box = BMFF::Box.get_box(io, self, BMFF::Box::URI)
    add_child @uri_box
    until eob?
      box = BMFF::Box.get_box(io, self)
      add_child box
      case box
      when BMFF::Box::URIInit
        @uri_init_box = box
      when BMFF::Box::BitRate
        @mpeg4_bit_rate_box = box
      end
    end
  end
end
