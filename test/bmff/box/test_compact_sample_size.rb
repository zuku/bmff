# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxCompactSampleSize < Minitest::Test
  def test_parse_filed_size_4
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stz2")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint24(0) # reserved1
    io.write_uint8(4) # field_size
    io.write_uint32(7) # sample_count
    io.write_uint8(18) # entry_size 1 + 2
    io.write_uint8(165) # entry_size 10 + 5
    io.write_uint8(15) # entry_size 0 + 15
    io.write_uint8(240) # entry_size 15 + 0 padding
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::CompactSampleSize, box)
    assert_equal(size, box.actual_size)
    assert_equal("stz2", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.reserved1)
    assert_equal(4, box.field_size)
    assert_equal(7, box.sample_count)
    assert_equal([1, 2, 10, 5, 0, 15, 15], box.entry_size)
  end

  def test_parse_filed_size_8
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stz2")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint24(0) # reserved1
    io.write_uint8(8) # field_size
    io.write_uint32(3) # sample_count
    3.times do |i|
      io.write_uint8(i) # entry_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::CompactSampleSize, box)
    assert_equal(size, box.actual_size)
    assert_equal("stz2", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.reserved1)
    assert_equal(8, box.field_size)
    assert_equal(3, box.sample_count)
    assert_equal([0, 1, 2], box.entry_size)
  end

  def test_parse_filed_size_16
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stz2")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint24(0) # reserved1
    io.write_uint8(16) # field_size
    io.write_uint32(3) # sample_count
    3.times do |i|
      io.write_uint16(i) # entry_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::CompactSampleSize, box)
    assert_equal(size, box.actual_size)
    assert_equal("stz2", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.reserved1)
    assert_equal(16, box.field_size)
    assert_equal(3, box.sample_count)
    assert_equal([0, 1, 2], box.entry_size)
  end
end
