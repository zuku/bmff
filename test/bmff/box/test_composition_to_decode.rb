# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxCompositionToDecode < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("cslg")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_int32(1) # composition_to_dts_shift
    io.write_int32(2) # least_decode_to_display_delta
    io.write_int32(3) # greatest_decode_to_display_delta
    io.write_int32(4) # composition_start_time
    io.write_int32(5) # composition_end_time
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::CompositionToDecode, box)
    assert_equal(size, box.actual_size)
    assert_equal("cslg", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.composition_to_dts_shift)
    assert_equal(2, box.least_decode_to_display_delta)
    assert_equal(3, box.greatest_decode_to_display_delta)
    assert_equal(4, box.composition_start_time)
    assert_equal(5, box.composition_end_time)
  end
end
