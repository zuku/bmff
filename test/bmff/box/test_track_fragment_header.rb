# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackFragmentHeader < Minitest::Test
  def test_parse_flags_full_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x01 | 0x02 | 0x08 | 0x10 | 0x20) # flags
    io.write_uint32(1) # track_id
    io.write_uint64(2) # base_data_offset
    io.write_uint32(3) # sample_description_index
    io.write_uint32(4) # default_sample_duration
    io.write_uint32(5) # default_sample_size
    io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(59, box.flags)
    assert_equal(1, box.track_id)
    assert_equal(2, box.base_data_offset)
    assert_equal(3, box.sample_description_index)
    assert_equal(4, box.default_sample_duration)
    assert_equal(5, box.default_sample_size)
    assert_equal(6, box.default_sample_flags)
  end

  def test_parse_flags_base_data_offset_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x01) # flags
    io.write_uint32(1) # track_id
    io.write_uint64(2) # base_data_offset
    #io.write_uint32(3) # sample_description_index
    #io.write_uint32(4) # default_sample_duration
    #io.write_uint32(5) # default_sample_size
    #io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal(1, box.track_id)
    assert_equal(2, box.base_data_offset)
    assert_nil(box.sample_description_index)
    assert_nil(box.default_sample_duration)
    assert_nil(box.default_sample_size)
    assert_nil(box.default_sample_flags)
  end

  def test_parse_flags_sample_description_index_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x02) # flags
    io.write_uint32(1) # track_id
    #io.write_uint64(2) # base_data_offset
    io.write_uint32(3) # sample_description_index
    #io.write_uint32(4) # default_sample_duration
    #io.write_uint32(5) # default_sample_size
    #io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(2, box.flags)
    assert_equal(1, box.track_id)
    assert_nil(box.base_data_offset)
    assert_equal(3, box.sample_description_index)
    assert_nil(box.default_sample_duration)
    assert_nil(box.default_sample_size)
    assert_nil(box.default_sample_flags)
  end

  def test_parse_flags_default_sample_duration_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x08) # flags
    io.write_uint32(1) # track_id
    #io.write_uint64(2) # base_data_offset
    #io.write_uint32(3) # sample_description_index
    io.write_uint32(4) # default_sample_duration
    #io.write_uint32(5) # default_sample_size
    #io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(8, box.flags)
    assert_equal(1, box.track_id)
    assert_nil(box.base_data_offset)
    assert_nil(box.sample_description_index)
    assert_equal(4, box.default_sample_duration)
    assert_nil(box.default_sample_size)
    assert_nil(box.default_sample_flags)
  end

  def test_parse_flags_default_sample_size_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x10) # flags
    io.write_uint32(1) # track_id
    #io.write_uint64(2) # base_data_offset
    #io.write_uint32(3) # sample_description_index
    #io.write_uint32(4) # default_sample_duration
    io.write_uint32(5) # default_sample_size
    #io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(16, box.flags)
    assert_equal(1, box.track_id)
    assert_nil(box.base_data_offset)
    assert_nil(box.sample_description_index)
    assert_nil(box.default_sample_duration)
    assert_equal(5, box.default_sample_size)
    assert_nil(box.default_sample_flags)
  end

  def test_parse_flags_default_sample_flags_present
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfhd")
    io.write_uint8(0) # version
    io.write_uint24(0x20) # flags
    io.write_uint32(1) # track_id
    #io.write_uint64(2) # base_data_offset
    #io.write_uint32(3) # sample_description_index
    #io.write_uint32(4) # default_sample_duration
    #io.write_uint32(5) # default_sample_size
    io.write_uint32(6) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfhd", box.type)
    assert_equal(0, box.version)
    assert_equal(32, box.flags)
    assert_equal(1, box.track_id)
    assert_nil(box.base_data_offset)
    assert_nil(box.sample_description_index)
    assert_nil(box.default_sample_duration)
    assert_nil(box.default_sample_size)
    assert_equal(6, box.default_sample_flags)
  end
end
