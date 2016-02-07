# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFSubsegmentIndex < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("ssix")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(2) # subsegment_count
    2.times do |i|
      io.write_uint32(i + 1) # range_count
      (i + 1).times do |j|
        io.write_uint8(j) # level
        io.write_uint24(j + 1) # range_size
      end
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SubsegmentIndex, box)
    assert_equal(size, box.actual_size)
    assert_equal("ssix", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(2, box.subsegment_count)
    assert_equal([1, 2], box.range_count)
    assert_equal(2, box.ranges.count)
    assert_equal([0], box.ranges[0].level)
    assert_equal([1], box.ranges[0].range_size)
    assert_equal([0, 1], box.ranges[1].level)
    assert_equal([1, 2], box.ranges[1].range_size)
  end
end
