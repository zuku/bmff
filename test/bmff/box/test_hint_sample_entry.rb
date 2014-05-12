# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxHintSampleEntry < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
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

    box = BMFF::Box.get_box(io, nil, BMFF::Box::HintSampleEntry)
    assert_instance_of(BMFF::Box::HintSampleEntry, box)
    assert_equal(size, box.actual_size)
    assert_equal("hint", box.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.reserved1)
    assert_equal(1, box.data_reference_index)
    assert_equal([0, 1, 2, 3], box.data)
  end
end
