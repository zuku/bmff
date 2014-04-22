# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::FileType < BMFF::Box::Base
  attr_accessor :major_brand, :minor_version, :compatible_brands

  def parse_data
    super
    @major_brand = io.get_ascii(4)
    @minor_version = io.get_uint32
    @compatible_brands = []
    until eob?
      @compatible_brands << io.get_ascii(4)
    end
  end
end
