# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackRun < Minitest::Test
  def test_parse_v0_flags_full_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x01 | 0x04 | 0x0100 | 0x0200 | 0x0400 | 0x0800) # flags
    io.write_uint32(3) # sample_count
    io.write_int32(2) # data_offset
    io.write_uint32(3) # first_sample_flags
    3.times do |i|
      io.write_uint32(4 + i) # sample_duration
      io.write_uint32(5 + i) # sample_size
      io.write_uint32(6 + i) # sample_flags
      io.write_uint32(7 + i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(3845, box.flags)
    assert_equal(3, box.sample_count)
    assert_equal(2, box.data_offset)
    assert_equal(3, box.first_sample_flags)
    assert_equal([4, 5, 6], box.sample_duration)
    assert_equal([5, 6, 7], box.sample_size)
    assert_equal([6, 7, 8], box.sample_flags)
    assert_equal([7, 8, 9], box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_data_offset_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x01) # flags
    io.write_uint32(3) # sample_count
    io.write_int32(2) # data_offset
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal(3, box.sample_count)
    assert_equal(2, box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_nil(box.sample_size)
    assert_nil(box.sample_flags)
    assert_nil(box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_first_sample_flags_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x04) # flags
    io.write_uint32(3) # sample_count
    io.write_uint32(3) # first_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(4, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_equal(3, box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_nil(box.sample_size)
    assert_nil(box.sample_flags)
    assert_nil(box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_sample_duration_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x0100) # flags
    io.write_uint32(3) # sample_count
    #io.write_int32(2) # data_offset
    #io.write_uint32(3) # first_sample_flags
    3.times do |i|
      io.write_uint32(4 + i) # sample_duration
      #io.write_uint32(5 + i) # sample_size
      #io.write_uint32(6 + i) # sample_flags
      #io.write_uint32(7 + i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(256, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_equal([4, 5, 6], box.sample_duration)
    assert_nil(box.sample_size)
    assert_nil(box.sample_flags)
    assert_nil(box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_sample_size_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x0200) # flags
    io.write_uint32(3) # sample_count
    #io.write_int32(2) # data_offset
    #io.write_uint32(3) # first_sample_flags
    3.times do |i|
      #io.write_uint32(4 + i) # sample_duration
      io.write_uint32(5 + i) # sample_size
      #io.write_uint32(6 + i) # sample_flags
      #io.write_uint32(7 + i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(512, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_equal([5, 6, 7], box.sample_size)
    assert_nil(box.sample_flags)
    assert_nil(box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_sample_flags_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x0400) # flags
    io.write_uint32(3) # sample_count
    #io.write_int32(2) # data_offset
    #io.write_uint32(3) # first_sample_flags
    3.times do |i|
      #io.write_uint32(4 + i) # sample_duration
      #io.write_uint32(5 + i) # sample_size
      io.write_uint32(6 + i) # sample_flags
      #io.write_uint32(7 + i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(1024, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_nil(box.sample_size)
    assert_equal([6, 7, 8], box.sample_flags)
    assert_nil(box.sample_composition_time_offset)
  end

  def test_parse_v0_flags_sample_composition_time_offset_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(0) # version
    io.write_uint24(0x0800) # flags
    io.write_uint32(3) # sample_count
    #io.write_int32(2) # data_offset
    #io.write_uint32(3) # first_sample_flags
    3.times do |i|
      #io.write_uint32(4 + i) # sample_duration
      #io.write_uint32(5 + i) # sample_size
      #io.write_uint32(6 + i) # sample_flags
      io.write_uint32(7 + i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(0, box.version)
    assert_equal(2048, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_nil(box.sample_size)
    assert_nil(box.sample_flags)
    assert_equal([7, 8, 9], box.sample_composition_time_offset)
  end

  def test_parse_v1_flags_sample_composition_time_offset_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trun")
    io.write_uint8(1) # version
    io.write_uint24(0x0800) # flags
    io.write_uint32(3) # sample_count
    #io.write_int32(2) # data_offset
    #io.write_uint32(3) # first_sample_flags
    3.times do |i|
      #io.write_uint32(4 + i) # sample_duration
      #io.write_uint32(5 + i) # sample_size
      #io.write_uint32(6 + i) # sample_flags
      io.write_int32(0 - i) # sample_composition_time_offset
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackRun, box)
    assert_equal(size, box.actual_size)
    assert_equal("trun", box.type)
    assert_equal(1, box.version)
    assert_equal(2048, box.flags)
    assert_equal(3, box.sample_count)
    assert_nil(box.data_offset)
    assert_nil(box.first_sample_flags)
    assert_nil(box.sample_duration)
    assert_nil(box.sample_size)
    assert_nil(box.sample_flags)
    assert_equal([0, -1, -2], box.sample_composition_time_offset)
  end
end
