# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackExtends < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("trex")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # track_id
    io.write_uint32(2) # default_sample_description_index
    io.write_uint32(3) # default_sample_duration
    io.write_uint32(4) # default_sample_size
    io.write_uint32(5) # default_sample_flags
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackExtends, box)
    assert_equal(size, box.actual_size)
    assert_equal("trex", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.track_id)
    assert_equal(2, box.default_sample_description_index)
    assert_equal(3, box.default_sample_duration)
    assert_equal(4, box.default_sample_size)
    assert_equal(5, box.default_sample_flags)
  end
end
