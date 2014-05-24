# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxVideoMediaHeader < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("vmhd")
    io.write_uint8(0) # version
    io.write_uint24(1) # flags
    io.write_uint16(0) # graphicsmode
    io.write_uint16(0) # opcolor
    io.write_uint16(0) # opcolor
    io.write_uint16(0) # opcolor
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::VideoMediaHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("vmhd", box.type)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal(0, box.graphicsmode)
    assert_equal([0, 0, 0], box.opcolor)
  end
end
