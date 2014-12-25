# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackFragmentRandomAccess < Minitest::Test
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfra")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # track_id
    io.write_uint32(6) # reserved1,
                       # length_size_of_traf_num (0),
                       # length_size_of_trun_num (1),
                       # length_size_of_sample_num (2)
    io.write_uint32(3) # number_of_entry
    3.times do |i|
      io.write_uint32(i) # time
      io.write_uint32(10 + i) # moof_offset

      io.write_uint8(20 + i) # traf_number
      io.write_uint16(30 + i) # trun_number
      io.write_uint24(40 + i) # sample_number
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentRandomAccess, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfra", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.track_id)
    assert_equal(0, box.reserved1)
    assert_equal(0, box.length_size_of_traf_num)
    assert_equal(1, box.length_size_of_trun_num)
    assert_equal(2, box.length_size_of_sample_num)
    assert_equal([0, 1, 2], box.time)
    assert_equal([10, 11, 12], box.moof_offset)
    assert_equal([20, 21, 22], box.traf_number)
    assert_equal([30, 31, 32], box.trun_number)
    assert_equal([40, 41, 42], box.sample_number)
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tfra")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # track_id
    io.write_uint32(57) # reserved1,
                        # length_size_of_traf_num (3),
                        # length_size_of_trun_num (2),
                        # length_size_of_sample_num (1)
    io.write_uint32(3) # number_of_entry
    3.times do |i|
      io.write_uint64(4294967296 + i) # time
      io.write_uint64(4294967306 + i) # moof_offset

      io.write_uint32(20 + i) # traf_number
      io.write_uint24(30 + i) # trun_number
      io.write_uint16(40 + i) # sample_number
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackFragmentRandomAccess, box)
    assert_equal(size, box.actual_size)
    assert_equal("tfra", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.track_id)
    assert_equal(0, box.reserved1)
    assert_equal(3, box.length_size_of_traf_num)
    assert_equal(2, box.length_size_of_trun_num)
    assert_equal(1, box.length_size_of_sample_num)
    assert_equal([4294967296, 4294967297, 4294967298], box.time)
    assert_equal([4294967306, 4294967307, 4294967308], box.moof_offset)
    assert_equal([20, 21, 22], box.traf_number)
    assert_equal([30, 31, 32], box.trun_number)
    assert_equal([40, 41, 42], box.sample_number)
  end
end
