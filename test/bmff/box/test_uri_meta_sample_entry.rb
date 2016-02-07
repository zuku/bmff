# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxURIMetaSampleEntry < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("urim")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(0) # data_reference_index
    # uri_box
    io.write_uint32(32)
    io.write_ascii("uri ")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_null_terminated_string("http://example.com/") # the_uri
    # uri_init_box
    io.write_uint32(15)
    io.write_ascii("uriI")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint8(0) # uri_initialization_data
    io.write_uint8(1) # uri_initialization_data
    io.write_uint8(2) # uri_initialization_data
    # mpeg4_bit_rate_box
    io.write_uint32(20)
    io.write_ascii("btrt")
    io.write_uint32(65535) # buffer_size_db
    io.write_uint32(1000000) # max_bitrate
    io.write_uint32(500000) # avg_bitrate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::URIMetaSampleEntry, box)
    assert_equal(size, box.actual_size)
    assert_equal("urim", box.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.reserved1)
    assert_equal(0, box.data_reference_index)

    assert_instance_of(BMFF::Box::URI, box.uri_box)
    assert_equal(32, box.uri_box.actual_size)
    assert_equal("uri ", box.uri_box.type)
    assert_equal(0, box.uri_box.version)
    assert_equal(0, box.uri_box.flags)
    assert_equal("http://example.com/", box.uri_box.the_uri)

    assert_instance_of(BMFF::Box::URIInit, box.uri_init_box)
    assert_equal(15, box.uri_init_box.actual_size)
    assert_equal("uriI", box.uri_init_box.type)
    assert_equal(0, box.uri_init_box.version)
    assert_equal(0, box.uri_init_box.flags)
    assert_equal([0, 1, 2], box.uri_init_box.uri_initialization_data)

    assert_instance_of(BMFF::Box::BitRate, box.mpeg4_bit_rate_box)
    assert_equal(20, box.mpeg4_bit_rate_box.actual_size)
    assert_equal("btrt", box.mpeg4_bit_rate_box.type)
    assert_equal(65535, box.mpeg4_bit_rate_box.buffer_size_db)
    assert_equal(1000000, box.mpeg4_bit_rate_box.max_bitrate)
    assert_equal(500000, box.mpeg4_bit_rate_box.avg_bitrate)
  end
end
