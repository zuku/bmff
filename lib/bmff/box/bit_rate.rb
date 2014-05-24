# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::BitRate < BMFF::Box::Base
  attr_accessor :buffer_size_db, :max_bitrate, :avg_bitrate
  register_box "btrt"

  def parse_data
    super
    @buffer_size_db = io.get_uint32
    @max_bitrate = io.get_uint32
    @avg_bitrate = io.get_uint32
  end
end
