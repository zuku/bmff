# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxLevelAssignment < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("leva")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint8(5) # level_count
    5.times do |i|
      io.write_uint32(i) # track_id
      io.write_uint8(i) # padding_flag, assignment_type
      case i
      when 0
        io.write_uint32(10 + i) # grouping_type
      when 1
        io.write_uint32(10 + i) # grouping_type
        io.write_uint32(20 + i) # grouping_type_parameter
      when 4
        io.write_uint32(30 + i) # sub_track_id
      end
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::LevelAssignment, box)
    assert_equal(size, box.actual_size)
    assert_equal("leva", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(5, box.level_count)
    assert_equal(5, box.levels.count)
    assert_equal([0, 1, 2, 3, 4], box.levels.map{|e| e.track_id})
    assert_equal([0, 0, 0, 0, 0], box.levels.map{|e| e.padding_flag})
    assert_equal([0, 1, 2, 3, 4], box.levels.map{|e| e.assignment_type})
    assert_equal([10, 11, nil, nil, nil], box.levels.map{|e| e.grouping_type})
    assert_equal([nil, 21, nil, nil, nil], box.levels.map{|e| e.grouping_type_parameter})
    assert_equal([nil, nil, nil, nil, 34], box.levels.map{|e| e.sub_track_id})
  end
end
