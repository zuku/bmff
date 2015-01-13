# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxBitRate < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("btrt")
    io.write_uint32(65535) # buffer_size_db
    io.write_uint32(1000000) # max_bitrate
    io.write_uint32(500000) # avg_bitrate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::BitRate, box)
    assert_equal(size, box.actual_size)
    assert_equal("btrt", box.type)
    assert_equal(65535, box.buffer_size_db)
    assert_equal(1000000, box.max_bitrate)
    assert_equal(500000, box.avg_bitrate)
  end
end
