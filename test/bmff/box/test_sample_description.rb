# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSampleDescription < MiniTest::Unit::TestCase
  class DummyBox
    attr_accessor :parent, :box
    def find(type)
      @box
    end
  end

  def get_handler(handler_type)
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hdlr")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # pre_defined
    io.write_ascii(handler_type) # handler_type
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    io.write_null_terminated_string("bmff test") # name
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    d1 = DummyBox.new
    d2 = DummyBox.new
    d3 = DummyBox.new
    d1.box = box
    d2.parent = d1
    d3.parent = d2
    d3
  end

  def test_parse_soun
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # entry_count
    # entry
    io.write_uint32(36)
    io.write_ascii("mp4a")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(1) # data_reference_index
    io.write_uint32(0) # reserved2
    io.write_uint32(0) # reserved2
    io.write_uint16(2) # channelcount
    io.write_uint16(16) # samplesize
    io.write_uint16(0) # pre_defined
    io.write_uint16(0) # reserved3
    io.write_uint32(2890137600) # samplerate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_handler("soun"))
    assert_instance_of(BMFF::Box::SampleDescription, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.entry_count)
    assert_equal(1, box.children.count)

    assert_instance_of(BMFF::Box::AudioSampleEntry, box.children.first)
    assert_equal(36, box.children.first.actual_size)
    assert_equal("mp4a", box.children.first.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.children.first.reserved1)
    assert_equal(1, box.children.first.data_reference_index)
    assert_equal([0, 0], box.children.first.reserved2)
    assert_equal(2, box.children.first.channelcount)
    assert_equal(16, box.children.first.samplesize)
    assert_equal(0, box.children.first.pre_defined)
    assert_equal(0, box.children.first.reserved3)
    assert_equal(2890137600, box.children.first.samplerate)
  end

  def test_parse_vide
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # entry_count
    # entry
    io.write_uint32(142)
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

    box = BMFF::Box.get_box(io, get_handler("vide"))
    assert_instance_of(BMFF::Box::SampleDescription, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.entry_count)
    assert_equal(1, box.children.count)

    assert_instance_of(BMFF::Box::VisualSampleEntry, box.children.first)
    assert_equal(142, box.children.first.actual_size)
    assert_equal("mp4v", box.children.first.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.children.first.reserved1)
    assert_equal(1, box.children.first.data_reference_index)
    assert_equal(0, box.children.first.pre_defined1)
    assert_equal(0, box.children.first.reserved2)
    assert_equal([0, 0, 0], box.children.first.pre_defined2)
    assert_equal(320, box.children.first.width)
    assert_equal(180, box.children.first.height)
    assert_equal(4718592, box.children.first.horizresolution)
    assert_equal(4718592, box.children.first.vertresolution)
    assert_equal(0, box.children.first.reserved3)
    assert_equal(1, box.children.first.frame_count)
    assert_equal("bmff", box.children.first.compressorname)
    assert_equal(24, box.children.first.depth)
    assert_equal(-1, box.children.first.pre_defined3)

    assert_instance_of(BMFF::Box::CleanAperture, box.children.first.clean_aperture_box)
    assert_equal(40, box.children.first.clean_aperture_box.actual_size)
    assert_equal("clap", box.children.first.clean_aperture_box.type)
    assert_equal(160, box.children.first.clean_aperture_box.clean_aperture_width_n)
    assert_equal(161, box.children.first.clean_aperture_box.clean_aperture_width_d)
    assert_equal(90, box.children.first.clean_aperture_box.clean_aperture_height_n)
    assert_equal(91, box.children.first.clean_aperture_box.clean_aperture_height_d)
    assert_equal(320, box.children.first.clean_aperture_box.horiz_off_n)
    assert_equal(321, box.children.first.clean_aperture_box.horiz_off_d)
    assert_equal(180, box.children.first.clean_aperture_box.vert_off_n)
    assert_equal(181, box.children.first.clean_aperture_box.vert_off_d)

    assert_instance_of(BMFF::Box::PixelAspectRatio, box.children.first.pixel_aspect_ratio_box)
    assert_equal(16, box.children.first.pixel_aspect_ratio_box.actual_size)
    assert_equal("pasp", box.children.first.pixel_aspect_ratio_box.type)
    assert_equal(16, box.children.first.pixel_aspect_ratio_box.h_spacing)
    assert_equal(9, box.children.first.pixel_aspect_ratio_box.v_spacing)
  end


  def test_parse_hint
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # entry_count
    # entry
    io.write_uint32(20)
    io.write_ascii("hint")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(1) # data_reference_index
    io.write_uint8(0) # data
    io.write_uint8(1) # data
    io.write_uint8(2) # data
    io.write_uint8(3) # data
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_handler("hint"))
    assert_instance_of(BMFF::Box::SampleDescription, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.entry_count)
    assert_equal(1, box.children.count)

    assert_instance_of(BMFF::Box::HintSampleEntry, box.children.first)
    assert_equal(20, box.children.first.actual_size)
    assert_equal("hint", box.children.first.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.children.first.reserved1)
    assert_equal(1, box.children.first.data_reference_index)
    assert_equal([0, 1, 2, 3], box.children.first.data)
  end

  def test_parse_meta_metx
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # entry_count
    # entry
    io.write_uint32(81)
    io.write_ascii("metx")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(0) # data_reference_index
    io.write_null_terminated_string("application/zip") # content_encoding
    io.write_null_terminated_string("NS") # namespace
    io.write_null_terminated_string("http://example.com/schema") # schema_location
    # bit_rate_box
    io.write_uint32(20)
    io.write_ascii("btrt")
    io.write_uint32(65535) # buffer_size_db
    io.write_uint32(1000000) # max_bitrate
    io.write_uint32(500000) # avg_bitrate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_handler("meta"))
    assert_instance_of(BMFF::Box::SampleDescription, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.entry_count)
    assert_equal(1, box.children.count)

    assert_instance_of(BMFF::Box::XMLMetaDataSampleEntry, box.children.first)
    assert_equal(81, box.children.first.actual_size)
    assert_equal("metx", box.children.first.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.children.first.reserved1)
    assert_equal(0, box.children.first.data_reference_index)
    assert_equal("application/zip", box.children.first.content_encoding)
    assert_equal("NS", box.children.first.namespace)
    assert_equal("http://example.com/schema", box.children.first.schema_location)

    assert_instance_of(BMFF::Box::BitRate, box.children.first.bit_rate_box)
    assert_equal(20, box.children.first.bit_rate_box.actual_size)
    assert_equal("btrt", box.children.first.bit_rate_box.type)
    assert_equal(65535, box.children.first.bit_rate_box.buffer_size_db)
    assert_equal(1000000, box.children.first.bit_rate_box.max_bitrate)
    assert_equal(500000, box.children.first.bit_rate_box.avg_bitrate)
  end

  def test_parse_meta_mett
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # entry_count
    # entry
    io.write_uint32(62)
    io.write_ascii("mett")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(0) # data_reference_index
    io.write_null_terminated_string("application/zip") # content_encoding
    io.write_null_terminated_string("text/html") # mime_format
    # bit_rate_box
    io.write_uint32(20)
    io.write_ascii("btrt")
    io.write_uint32(65535) # buffer_size_db
    io.write_uint32(1000000) # max_bitrate
    io.write_uint32(500000) # avg_bitrate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_handler("meta"))
    assert_instance_of(BMFF::Box::SampleDescription, box)
    assert_equal(size, box.actual_size)
    assert_equal("stsd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.entry_count)
    assert_equal(1, box.children.count)

    assert_instance_of(BMFF::Box::TextMetaDataSampleEntry, box.children.first)
    assert_equal(62, box.children.first.actual_size)
    assert_equal("mett", box.children.first.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.children.first.reserved1)
    assert_equal(0, box.children.first.data_reference_index)
    assert_equal("application/zip", box.children.first.content_encoding)
    assert_equal("text/html", box.children.first.mime_format)

    assert_instance_of(BMFF::Box::BitRate, box.children.first.bit_rate_box)
    assert_equal(20, box.children.first.bit_rate_box.actual_size)
    assert_equal("btrt", box.children.first.bit_rate_box.type)
    assert_equal(65535, box.children.first.bit_rate_box.buffer_size_db)
    assert_equal(1000000, box.children.first.bit_rate_box.max_bitrate)
    assert_equal(500000, box.children.first.bit_rate_box.avg_bitrate)
  end
end
