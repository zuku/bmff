# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSampleAuxiliaryInformationSizes < MiniTest::Unit::TestCase
  def test_parse_flags_0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("saiz")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint8(0) # default_sample_info_size
    io.write_uint32(3) # sample_count
    3.times do |i|
      io.write_uint8(i) # sample_info_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SampleAuxiliaryInformationSizes, box)
    assert_equal(size, box.actual_size)
    assert_equal("saiz", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_nil(box.aux_info_type)
    assert_nil(box.aux_info_type_parameter)
    assert_equal(0, box.default_sample_info_size)
    assert_equal(3, box.sample_count)
    assert_equal([0, 1, 2], box.sample_info_size)
  end

  def test_parse_flags_1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("saiz")
    io.write_uint8(0) # version
    io.write_uint24(1) # flags
    io.write_uint32(1) # aux_info_type
    io.write_uint32(2) # aux_info_type_parameter
    io.write_uint8(0) # default_sample_info_size
    io.write_uint32(3) # sample_count
    3.times do |i|
      io.write_uint8(i) # sample_info_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SampleAuxiliaryInformationSizes, box)
    assert_equal(size, box.actual_size)
    assert_equal("saiz", box.type)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal(1, box.aux_info_type)
    assert_equal(2, box.aux_info_type_parameter)
    assert_equal(0, box.default_sample_info_size)
    assert_equal(3, box.sample_count)
    assert_equal([0, 1, 2], box.sample_info_size)
  end
end
