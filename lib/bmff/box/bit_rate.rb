# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::BitRate < BMFF::Box::Base
  attr_accessor :buffersizedb, :maxbitrate, :avgbitrate
  register_box "btrt"

  def parse_data
    super
    @buffersizedb = io.get_uint32
    @maxbitrate = io.get_uint32
    @avgbitrate = io.get_uint32
  end
end
