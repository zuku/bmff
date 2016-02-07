# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSegmentType < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("styp")
    io.write_ascii("msdh") # major_brand
    io.write_uint32(0) # minor_version
    io.write_ascii("msdhmsix") # compatible_brands
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SegmentType, box)
    assert_equal(size, box.actual_size)
    assert_equal("styp", box.type)
    assert_equal("msdh", box.major_brand)
    assert_equal(0, box.minor_version)
    assert_equal(%w(msdh msix), box.compatible_brands)
  end
end
