# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::URIInit < BMFF::Box::Full
  attr_accessor :uri_initialization_data
  register_box "uriI"

  def parse_data
    super
    @uri_initialization_data = []
    until eob?
      @uri_initialization_data << io.get_uint8
    end
  end
end
