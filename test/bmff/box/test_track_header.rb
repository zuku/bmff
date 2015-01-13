# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackHeader < Minitest::Test
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tkhd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(3482338006) # creation_time
    io.write_uint32(3482338007) # modification_time
    io.write_uint32(1) # track_id
    io.write_uint32(0) # reserved1
    io.write_uint32(30000000) # duration
    io.write_uint32(0) # reserved2
    io.write_uint32(0) # reserved2
    io.write_int16(0) # layer
    io.write_int16(0) # alternate_group
    io.write_int16(256) # volume
    io.write_uint16(0) # reserved3
    io.write_int32(65536) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(65536) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(1073741824) # matrix
    io.write_uint32(1920)
    io.write_uint32(1080)
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tkhd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(3482338006, box.creation_time)
    assert_equal(3482338007, box.modification_time)
    assert_equal(1, box.track_id)
    assert_equal(0, box.reserved1)
    assert_equal(30000000, box.duration)
    assert_equal([0, 0], box.reserved2)
    assert_equal(0, box.layer)
    assert_equal(0, box.alternate_group)
    assert_equal(256, box.volume)
    assert_equal(0, box.reserved3)
    assert_equal([65536, 0, 0, 0, 65536, 0, 0, 0, 1073741824], box.matrix)
    assert_equal(1920, box.width)
    assert_equal(1080, box.height)
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tkhd")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint64(3482338006) # creation_time
    io.write_uint64(3482338007) # modification_time
    io.write_uint32(1) # track_id
    io.write_uint32(0) # reserved1
    io.write_uint64(30000000) # duration
    io.write_uint32(0) # reserved2
    io.write_uint32(0) # reserved2
    io.write_int16(0) # layer
    io.write_int16(0) # alternate_group
    io.write_int16(0) # volume
    io.write_uint16(0) # reserved3
    io.write_int32(65536) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(65536) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(0) # matrix
    io.write_int32(1073741824) # matrix
    io.write_uint32(1920)
    io.write_uint32(1080)
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tkhd", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(3482338006, box.creation_time)
    assert_equal(3482338007, box.modification_time)
    assert_equal(1, box.track_id)
    assert_equal(0, box.reserved1)
    assert_equal(30000000, box.duration)
    assert_equal([0, 0], box.reserved2)
    assert_equal(0, box.layer)
    assert_equal(0, box.alternate_group)
    assert_equal(0, box.volume)
    assert_equal(0, box.reserved3)
    assert_equal([65536, 0, 0, 0, 65536, 0, 0, 0, 1073741824], box.matrix)
    assert_equal(1920, box.width)
    assert_equal(1080, box.height)
  end
end
