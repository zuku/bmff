# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxMediaHeader < MiniTest::Unit::TestCase
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("mdhd")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(3482338006) # creation_time
    io.write_uint32(3482338007) # modification_time
    io.write_uint32(1000000) # timescale
    io.write_uint32(30000000) # duration
    io.write_byte("\x15\xC7") # language (eng)
    io.write_uint16(0) # pre_defined
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::MediaHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("mdhd", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(3482338006, box.creation_time)
    assert_equal(3482338007, box.modification_time)
    assert_equal(1000000, box.timescale)
    assert_equal(30000000, box.duration)
    assert_equal("eng", box.language)
    assert_equal(0, box.pre_defined)
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("mdhd")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint64(3482338006) # creation_time
    io.write_uint64(3482338007) # modification_time
    io.write_uint32(1000000) # timescale
    io.write_uint64(30000000) # duration
    io.write_byte("\x2A\x0E") # language (jpn)
    io.write_uint16(0) # pre_defined
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::MediaHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("mdhd", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(3482338006, box.creation_time)
    assert_equal(3482338007, box.modification_time)
    assert_equal(1000000, box.timescale)
    assert_equal(30000000, box.duration)
    assert_equal("jpn", box.language)
    assert_equal(0, box.pre_defined)
  end
end
