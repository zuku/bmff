# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxFreeSpace < MiniTest::Unit::TestCase
  def test_parse_free
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("free")
    io.write_byte("abcdefg") # data
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::FreeSpace, box)
    assert_equal(size, box.actual_size)
    assert_equal("free", box.type)
  end

  def test_parse_skip
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("skip")
    io.write_byte("abcdefg") # data
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::FreeSpace, box)
    assert_equal(size, box.actual_size)
    assert_equal("skip", box.type)
  end
end
