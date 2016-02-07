# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTextMetaDataSampleEntry < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
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

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TextMetaDataSampleEntry, box)
    assert_equal(size, box.actual_size)
    assert_equal("mett", box.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.reserved1)
    assert_equal(0, box.data_reference_index)
    assert_equal("application/zip", box.content_encoding)
    assert_equal("text/html", box.mime_format)
    assert_instance_of(BMFF::Box::BitRate, box.bit_rate_box)
    assert_equal(20, box.bit_rate_box.actual_size)
    assert_equal("btrt", box.bit_rate_box.type)
    assert_equal(65535, box.bit_rate_box.buffer_size_db)
    assert_equal(1000000, box.bit_rate_box.max_bitrate)
    assert_equal(500000, box.bit_rate_box.avg_bitrate)
  end
end
