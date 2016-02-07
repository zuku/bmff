# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxVisualSampleEntry < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("mp4v")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(1) # data_reference_index
    io.write_uint16(0) # pre_defined1
    io.write_uint16(0) # reserved2
    io.write_uint32(0) # pre_defined2
    io.write_uint32(0) # pre_defined2
    io.write_uint32(0) # pre_defined2
    io.write_uint16(320) # width
    io.write_uint16(180) # height
    io.write_uint32(4718592) # horizresolution
    io.write_uint32(4718592) # vertresolution
    io.write_uint32(0) # reserved3
    io.write_uint16(1) # frame_count
    io.write_byte("\x04") # compressorname (size)
    io.write_ascii("bmff") # compressorname
    io.write_byte("\x00" * 27) # compressorname (padding)
    io.write_uint16(24) # depth
    io.write_int16(-1) # pre_defined3
    # clean_aperture_box
    io.write_uint32(40)
    io.write_ascii("clap")
    io.write_uint32(160) # clean_aperture_width_n
    io.write_uint32(161) # clean_aperture_width_d
    io.write_uint32(90) # clean_aperture_height_n
    io.write_uint32(91) # clean_aperture_height_d
    io.write_uint32(320) # horiz_off_n
    io.write_uint32(321) # horiz_off_d
    io.write_uint32(180) # vert_off_n
    io.write_uint32(181) # vert_off_d
    # pixel_aspect_ratio_box
    io.write_uint32(16)
    io.write_ascii("pasp")
    io.write_uint32(16) # h_spacing
    io.write_uint32(9) # v_spacing
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil, BMFF::Box::VisualSampleEntry)
    assert_instance_of(BMFF::Box::VisualSampleEntry, box)
    assert_equal(size, box.actual_size)
    assert_equal("mp4v", box.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.reserved1)
    assert_equal(1, box.data_reference_index)
    assert_equal(0, box.pre_defined1)
    assert_equal(0, box.reserved2)
    assert_equal([0, 0, 0], box.pre_defined2)
    assert_equal(320, box.width)
    assert_equal(180, box.height)
    assert_equal(4718592, box.horizresolution)
    assert_equal(4718592, box.vertresolution)
    assert_equal(0, box.reserved3)
    assert_equal(1, box.frame_count)
    assert_equal("bmff", box.compressorname)
    assert_equal(24, box.depth)
    assert_equal(-1, box.pre_defined3)

    assert_instance_of(BMFF::Box::CleanAperture, box.clean_aperture_box)
    assert_equal(40, box.clean_aperture_box.actual_size)
    assert_equal("clap", box.clean_aperture_box.type)
    assert_equal(160, box.clean_aperture_box.clean_aperture_width_n)
    assert_equal(161, box.clean_aperture_box.clean_aperture_width_d)
    assert_equal(90, box.clean_aperture_box.clean_aperture_height_n)
    assert_equal(91, box.clean_aperture_box.clean_aperture_height_d)
    assert_equal(320, box.clean_aperture_box.horiz_off_n)
    assert_equal(321, box.clean_aperture_box.horiz_off_d)
    assert_equal(180, box.clean_aperture_box.vert_off_n)
    assert_equal(181, box.clean_aperture_box.vert_off_d)

    assert_instance_of(BMFF::Box::PixelAspectRatio, box.pixel_aspect_ratio_box)
    assert_equal(16, box.pixel_aspect_ratio_box.actual_size)
    assert_equal("pasp", box.pixel_aspect_ratio_box.type)
    assert_equal(16, box.pixel_aspect_ratio_box.h_spacing)
    assert_equal(9, box.pixel_aspect_ratio_box.v_spacing)
  end
end
