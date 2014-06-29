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
require "bmff/box/sample_entry"
require "bmff/box/hint_sample_entry"
require "bmff/box/bit_rate"
require "bmff/box/meta_data_sample_entry"
require "bmff/box/xml_meta_data_sample_entry"
require "bmff/box/text_meta_data_sample_entry"
require "bmff/box/uri"
require "bmff/box/uri_init"
require "bmff/box/uri_meta_sample_entry"
require "bmff/box/pixel_aspect_ratio"
require "bmff/box/clean_aperture"
require "bmff/box/colour_information"
require "bmff/box/visual_sample_entry"
require "bmff/box/audio_sample_entry"
require "bmff/box/sample_description"
require "bmff/box/sample_size"
require "bmff/box/compact_sample_size"
require "bmff/box/degradation_priority"
require "bmff/box/time_to_sample"
require "bmff/box/composition_offset"
require "bmff/box/composition_to_decode"
require "bmff/box/sync_sample"
require "bmff/box/shadow_sync_sample"
require "bmff/box/sample_dependency_type"
require "bmff/box/edit"
require "bmff/box/edit_list"
require "bmff/box/data_information"
require "bmff/box/data_entry_url"
require "bmff/box/data_entry_urn"
require "bmff/box/data_reference"
require "bmff/box/sample_to_chunk"
require "bmff/box/chunk_offset"
require "bmff/box/chunk_large_offset"
require "bmff/box/padding_bits"
require "bmff/box/sub_sample_information"
require "bmff/box/sample_auxiliary_information_sizes"
require "bmff/box/sample_auxiliary_information_offsets"
require "bmff/box/movie_extends"
require "bmff/box/movie_extends_header"
require "bmff/box/track_extends"
require "bmff/box/movie_fragment"
require "bmff/box/movie_fragment_header"
require "bmff/box/track_fragment"
require "bmff/box/track_fragment_header"
require "bmff/box/track_run"
require "bmff/box/movie_fragment_random_access"
require "bmff/box/track_fragment_random_access"
require "bmff/box/movie_fragment_random_access_offset"
require "bmff/box/track_fragment_base_media_decode_time"
require "bmff/box/level_assignment"
require "bmff/box/user_data"
require "bmff/box/copyright"
require "bmff/box/track_selection"
require "bmff/box/protection_scheme_info"
require "bmff/box/original_format"
require "bmff/box/scheme_type"
require "bmff/box/scheme_information"

# UUID boxes
require "bmff/box/protection_system_specific_header"
require "bmff/box/track_encryption"
require "bmff/box/sample_encryption"

module BMFF::Box
  def self.get_box(io, parent, box_class = nil)
    offset = io.pos
    size = io.get_uint32
    type = io.get_ascii(4)
    largesize = nil
    if size == 1
      largesize = io.get_uint64
    end
    usertype = nil
    if type == 'uuid'
      usertype = io.get_uuid
    end

    if box_class
      klass = box_class
    else
      if usertype
        klass = get_uuid_box_class(usertype)
      else
        klass = get_box_class(type)
      end
    end
    klass ||= BMFF::Box::Unknown
    box = klass.new
    box.io = io
    box.offset = offset
    box.parent = parent
    box.size = size
    box.type = type
    box.largesize = largesize
    box.usertype = usertype

    box.parse
    return box
  end

  def self.get_box_class(type)
    Map.get_box_class(type)
  end

  def self.get_uuid_box_class(uuid)
    Map.get_uuid_box_class(uuid)
  end
end
