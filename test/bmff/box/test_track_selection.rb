# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackSelection < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tsel")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_int32(0) # switch_group
    io.write_ascii("tesc") # attribute_list
    io.write_ascii("cdec") # attribute_list
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackSelection, box)
    assert_equal(size, box.actual_size)
    assert_equal("tsel", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.switch_group)
    assert_equal(["tesc", "cdec"], box.attribute_list)
  end
end
