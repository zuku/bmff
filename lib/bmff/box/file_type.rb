# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::FileType < BMFF::Box::Base
  attr_accessor :major_brand, :minor_version, :compatible_brands

  def parse_data
    super
    @major_brand = io.sysread(4).unpack("a4").first
    @minor_version = io.sysread(4).unpack("N").first
    @compatible_brands = []
    until eob?
      @compatible_brands << io.sysread(4).unpack("a4").first
    end
  end
end
