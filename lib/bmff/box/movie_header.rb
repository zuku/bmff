# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MovieHeader < BMFF::Box::Full
  attr_accessor :creation_time, :modification_time, :timescale, :duration,
                :rate, :volume, :reserved1, :reserved2, :matrix, :pre_defined, :next_track_id
  register_box "mvhd"

  def parse_data
    super
    if version == 1
      @creation_time = io.get_uint64
      @modification_time = io.get_uint64
      @timescale = io.get_uint32
      @duration = io.get_uint64
    else
      @creation_time = io.get_uint32
      @modification_time = io.get_uint32
      @timescale = io.get_uint32
      @duration = io.get_uint32
    end
    @rate = io.get_int32
    @volume = io.get_int16
    @reserved1 = io.get_byte(2)
    @reserved2 = [io.get_uint32, io.get_uint32]
    @matrix = []
    9.times do
      @matrix << io.get_int32
    end
    @pre_defined = []
    6.times do
      @pre_defined << io.get_byte(4)
    end
    @next_track_id = io.get_uint32
  end
end
