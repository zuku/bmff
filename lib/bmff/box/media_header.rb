# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MediaHeader < BMFF::Box::Full
  attr_accessor :creation_time, :modification_time, :timescale, :duration,
                :language, :pre_defined
  register_box "mdhd"

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
    @language = io.get_iso639_2_language
    @pre_defined = io.get_uint16
  end
end
