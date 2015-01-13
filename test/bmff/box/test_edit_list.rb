# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxEditList < Minitest::Test
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("elst")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(3) # entry_count
    3.times do |i|
      io.write_uint32(10 + i) # segment_duration
      io.write_int32(20 + i) # media_time
      io.write_int16(i) # media_rate_integer
      io.write_int16(0) # media_rate_fraction
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::EditList, box)
    assert_equal(size, box.actual_size)
    assert_equal("elst", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(3, box.entry_count)
    assert_equal([10, 11, 12], box.segment_duration)
    assert_equal([20, 21, 22], box.media_time)
    assert_equal([0, 1, 2], box.media_rate_integer)
    assert_equal([0, 0, 0], box.media_rate_fraction)
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("elst")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint32(3) # entry_count
    3.times do |i|
      io.write_uint64(10 + i) # segment_duration
      io.write_int64(20 + i) # media_time
      io.write_int16(i) # media_rate_integer
      io.write_int16(0) # media_rate_fraction
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::EditList, box)
    assert_equal(size, box.actual_size)
    assert_equal("elst", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(3, box.entry_count)
    assert_equal([10, 11, 12], box.segment_duration)
    assert_equal([20, 21, 22], box.media_time)
    assert_equal([0, 1, 2], box.media_rate_integer)
    assert_equal([0, 0, 0], box.media_rate_fraction)
  end
end
