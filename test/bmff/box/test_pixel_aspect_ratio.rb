# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxPixelAspectRatio < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("pasp")
    io.write_uint32(16) # h_spacing
    io.write_uint32(9) # v_spacing
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::PixelAspectRatio, box)
    assert_equal(size, box.actual_size)
    assert_equal("pasp", box.type)
    assert_equal(16, box.h_spacing)
    assert_equal(9, box.v_spacing)
  end
end
