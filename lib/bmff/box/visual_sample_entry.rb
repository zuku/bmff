# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::VisualSampleEntry < BMFF::Box::SampleEntry
  attr_accessor :pre_defined1, :reserved2, :pre_defined2, :width, :height, :horizresolution, :vertresolution,
                :reserved3, :frame_count, :compressorname, :depth, :pre_defined3,
                :clean_aperture_box, :pixel_aspect_ratio_box
  include(BMFF::Box::Container)

  def parse_data
    super
    @pre_defined1 = io.get_uint16
    @reserved2 = io.get_uint16
    @pre_defined2 = [io.get_uint32, io.get_uint32, io.get_uint32]
    @width = io.get_uint16
    @height = io.get_uint16
    @horizresolution = io.get_uint32
    @vertresolution = io.get_uint32
    @reserved3 = io.get_uint32
    @frame_count = io.get_uint16
    compressorname_size = io.get_uint8 & 0x1F
    compressorname_buffer = io.get_ascii(31)
    @compressorname = compressorname_buffer[0, compressorname_size]
    @depth = io.get_uint16
    @pre_defined3 = io.get_int16
    until eob?
      box = BMFF::Box.get_box(io, self)
      add_child box
      case box
      when BMFF::Box::CleanAperture
        @clean_aperture_box = box
      when BMFF::Box::PixelAspectRatio
        @pixel_aspect_ratio_box = box
      end
    end
  end
end
