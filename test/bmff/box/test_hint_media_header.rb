# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxHintMediaHeader < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hmhd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint16(10) # max_pdu_size
    io.write_uint16(5) # avg_pdu_size
    io.write_uint32(1000000) # maxbitrate
    io.write_uint32(500000) # avgbitrate
    io.write_uint32(0) # reserved1
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::HintMediaHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("hmhd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(10, box.max_pdu_size)
    assert_equal(5, box.avg_pdu_size)
    assert_equal(1000000, box.maxbitrate)
    assert_equal(500000, box.avgbitrate)
    assert_equal(0, box.reserved1)
  end
end
