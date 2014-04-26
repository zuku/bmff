# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

module BMFF::Box; end

require "bmff/box/map"
require "bmff/box/base"
require "bmff/box/full"
require "bmff/box/container"
require "bmff/box/unknown"

require "bmff/box/file_type"
require "bmff/box/media_data"
require "bmff/box/free_space"
require "bmff/box/progressive_download_info"
require "bmff/box/movie"
require "bmff/box/movie_header"
require "bmff/box/track"
require "bmff/box/track_header"
require "bmff/box/track_reference"
require "bmff/box/track_reference_type"
require "bmff/box/track_group"
require "bmff/box/track_group_type"
require "bmff/box/media"
require "bmff/box/media_header"
require "bmff/box/handler"
require "bmff/box/media_information"
require "bmff/box/video_media_header"
require "bmff/box/sound_media_header"
require "bmff/box/hint_media_header"
require "bmff/box/null_media_header"
require "bmff/box/sample_table"

module BMFF::Box
  def self.get_box(io, parent)
    offset = io.pos
    size = io.get_uint32
    type = io.get_ascii(4)

    klass = get_box_class(type)
    box = klass.new
    box.io = io
    box.offset = offset
    box.parent = parent
    box.size = size
    box.type = type

    box.parse
    return box
  end

  def self.get_box_class(type)
    if klass = Map.get_box_class(type)
      return klass
    end
    return BMFF::Box::Unknown
  end
end
