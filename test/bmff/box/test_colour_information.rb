# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxColourInformation < MiniTest::Unit::TestCase
  def test_parse_nclx
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("colr")
    io.write_ascii("nclx") # colour_type
    io.write_uint16(1) # colour_primaries
    io.write_uint16(2) # transfer_characteristics
    io.write_uint16(3) # matrix_coefficients
    io.write_uint8(128) # full_range_flag reserved
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ColourInformation, box)
    assert_equal(size, box.actual_size)
    assert_equal("colr", box.type)
    assert_equal("nclx", box.colour_type)
    assert_equal(1, box.colour_primaries)
    assert_equal(2, box.transfer_characteristics)
    assert_equal(3, box.matrix_coefficients)
    assert(box.full_range_flag)
    assert_equal(0, box.reserved1)
  end

  def test_parse_ricc
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("colr")
    io.write_ascii("rICC") # colour_type
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ColourInformation, box)
    assert_equal(size, box.actual_size)
    assert_equal("colr", box.type)
    assert_equal("rICC", box.colour_type)
    assert_equal(:restricted, box.icc_profile)
  end

  def test_parse_prof
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("colr")
    io.write_ascii("prof") # colour_type
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ColourInformation, box)
    assert_equal(size, box.actual_size)
    assert_equal("colr", box.type)
    assert_equal("prof", box.colour_type)
    assert_equal(:unrestricted, box.icc_profile)
  end
end
