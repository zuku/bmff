# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSubSampleInformation < Minitest::Test
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("subs")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(3) # entry_count
    # entry
    3.times do |i|
      io.write_uint32(i) # sample_delta
      io.write_uint16(2) # subsample_count
      2.times do |j|
        io.write_uint16(j) # subsample_size
        io.write_uint8(10 + j) # subsample_priority
        io.write_uint8(0) # discardable
        io.write_uint32(0) # reserved1
      end
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SubSampleInformation, box)
    assert_equal(size, box.actual_size)
    assert_equal("subs", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(3, box.entry_count)
    assert_equal([0, 1, 2], box.sample_delta)
    assert_equal([2, 2, 2], box.subsample_count)
    3.times do |i|
      assert_equal([0, 1], box.subsamples[i].subsample_size)
      assert_equal([10, 11], box.subsamples[i].subsample_priority)
      assert_equal([0, 0], box.subsamples[i].discardable)
      assert_equal([0, 0], box.subsamples[i].reserved1)
    end
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("subs")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint32(3) # entry_count
    # entry
    3.times do |i|
      io.write_uint32(i) # sample_delta
      io.write_uint16(2) # subsample_count
      2.times do |j|
        io.write_uint32(j) # subsample_size
        io.write_uint8(10 + j) # subsample_priority
        io.write_uint8(0) # discardable
        io.write_uint32(0) # reserved1
      end
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SubSampleInformation, box)
    assert_equal(size, box.actual_size)
    assert_equal("subs", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(3, box.entry_count)
    assert_equal([0, 1, 2], box.sample_delta)
    assert_equal([2, 2, 2], box.subsample_count)
    3.times do |i|
      assert_equal([0, 1], box.subsamples[i].subsample_size)
      assert_equal([10, 11], box.subsamples[i].subsample_priority)
      assert_equal([0, 0], box.subsamples[i].discardable)
      assert_equal([0, 0], box.subsamples[i].reserved1)
    end
  end
end
