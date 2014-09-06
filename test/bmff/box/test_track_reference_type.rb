# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackReferenceType < MiniTest::Unit::TestCase
  def test_parse_hint
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hint")
    io.write_uint32(1) # track_ids
    io.write_uint32(2) # track_ids
    io.write_uint32(3) # track_ids
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackReferenceType, box)
    assert_equal(size, box.actual_size)
    assert_equal("hint", box.type)
    assert_equal([1, 2, 3], box.track_ids)
  end

  def test_parse_cdsc
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("cdsc")
    io.write_uint32(1) # track_ids
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackReferenceType, box)
    assert_equal(size, box.actual_size)
    assert_equal("cdsc", box.type)
    assert_equal([1], box.track_ids)
  end

  def test_parse_hind
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hind")
    io.write_uint32(1) # track_ids
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackReferenceType, box)
    assert_equal(size, box.actual_size)
    assert_equal("hind", box.type)
    assert_equal([1], box.track_ids)
  end

  def test_parse_vdep
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("vdep")
    io.write_uint32(1) # track_ids
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackReferenceType, box)
    assert_equal(size, box.actual_size)
    assert_equal("vdep", box.type)
    assert_equal([1], box.track_ids)
  end

  def test_parse_vplx
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("vplx")
    io.write_uint32(1) # track_ids
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackReferenceType, box)
    assert_equal(size, box.actual_size)
    assert_equal("vplx", box.type)
    assert_equal([1], box.track_ids)
  end
end
