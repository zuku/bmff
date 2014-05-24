# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackHeader < BMFF::Box::Full
  attr_accessor :creation_time, :modification_time, :track_id, :reserved1, :duration,
                :reserved2, :layer, :alternate_group, :volume, :reserved3, :matrix, :width, :height
  register_box "tkhd"

  def parse_data
    super
    if version == 1
      @creation_time = io.get_uint64
      @modification_time = io.get_uint64
      @track_id = io.get_uint32
      @reserved1 = io.get_uint32
      @duration = io.get_uint64
    else
      @creation_time = io.get_uint32
      @modification_time = io.get_uint32
      @track_id = io.get_uint32
      @reserved1 = io.get_uint32
      @duration = io.get_uint32
    end
    @reserved2 = [io.get_uint32, io.get_uint32]
    @layer = io.get_int16
    @alternate_group = io.get_int16
    @volume = io.get_int16
    @reserved3 = io.get_uint16
    @matrix = []
    9.times do
      @matrix << io.get_int32
    end
    @width = io.get_uint32
    @height = io.get_uint32
  end
end
