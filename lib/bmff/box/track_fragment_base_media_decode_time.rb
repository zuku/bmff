# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackFragmentBaseMediaDecodeTime < BMFF::Box::Full
  attr_accessor :base_media_decode_time
  register_box "tfdt"

  def parse_data
    super
    if version == 1
      @base_media_decode_time = io.get_uint64
    else
      @base_media_decode_time = io.get_uint32
    end
  end
end
