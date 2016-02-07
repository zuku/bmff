# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFSegmentIndex < Minitest::Test
  def test_parse_v0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("sidx")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # reference_id
    io.write_uint32(30000) # timescale
    io.write_uint32(1) # earliest_presentation_time
    io.write_uint32(2) # first_offset
    io.write_uint16(0) # reserved1
    io.write_uint16(3) # reference_count
    # reference
    io.write_uint32(1 << 31 | 1) # reference_type(1) + referenced_size(31)
    io.write_uint32(10) # subsegment_duration
    io.write_uint32(1 << 31 | 1 << 28 | 11) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    io.write_uint32(2) # reference_type(1) + referenced_size(31)
    io.write_uint32(20) # subsegment_duration
    io.write_uint32(1 << 29 | 22) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    io.write_uint32(1 << 31 | 3) # reference_type(1) + referenced_size(31)
    io.write_uint32(30) # subsegment_duration
    io.write_uint32(1 << 31 | 1 << 30 | 33) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SegmentIndex, box)
    assert_equal(size, box.actual_size)
    assert_equal("sidx", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.reference_id)
    assert_equal(30000, box.timescale)
    assert_equal(1, box.earliest_presentation_time)
    assert_equal(2, box.first_offset)
    assert_equal(0, box.reserved1)
    assert_equal(3, box.reference_count)
    assert_equal([true, false, true], box.reference_type)
    assert_equal([1, 2, 3], box.referenced_size)
    assert_equal([10, 20, 30], box.subsegment_duration)
    assert_equal([true, false, true], box.start_with_sap)
    assert_equal([1, 2, 4], box.sap_type)
    assert_equal([11, 22, 33], box.sap_delta_time)
  end

  def test_parse_v1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("sidx")
    io.write_uint8(1) # version
    io.write_uint24(0) # flags
    io.write_uint32(1) # reference_id
    io.write_uint32(30000) # timescale
    io.write_uint64(1) # earliest_presentation_time
    io.write_uint64(2) # first_offset
    io.write_uint16(0) # reserved1
    io.write_uint16(3) # reference_count
    # reference
    io.write_uint32(1 << 31 | 1) # reference_type(1) + referenced_size(31)
    io.write_uint32(10) # subsegment_duration
    io.write_uint32(1 << 31 | 1 << 28 | 11) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    io.write_uint32(2) # reference_type(1) + referenced_size(31)
    io.write_uint32(20) # subsegment_duration
    io.write_uint32(1 << 29 | 22) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    io.write_uint32(1 << 31 | 3) # reference_type(1) + referenced_size(31)
    io.write_uint32(30) # subsegment_duration
    io.write_uint32(1 << 31 | 1 << 30 | 33) # starts_with_sap(1) + sap_type(3) + sap_delta_time(28)

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SegmentIndex, box)
    assert_equal(size, box.actual_size)
    assert_equal("sidx", box.type)
    assert_equal(1, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.reference_id)
    assert_equal(30000, box.timescale)
    assert_equal(1, box.earliest_presentation_time)
    assert_equal(2, box.first_offset)
    assert_equal(0, box.reserved1)
    assert_equal(3, box.reference_count)
    assert_equal([true, false, true], box.reference_type)
    assert_equal([1, 2, 3], box.referenced_size)
    assert_equal([10, 20, 30], box.subsegment_duration)
    assert_equal([true, false, true], box.start_with_sap)
    assert_equal([1, 2, 4], box.sap_type)
    assert_equal([11, 22, 33], box.sap_delta_time)
  end
end
