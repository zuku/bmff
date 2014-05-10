# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxNullMediaHeader < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("nmhd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::NullMediaHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("nmhd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
  end
end
