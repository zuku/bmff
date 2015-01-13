# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxDegradationPriority < Minitest::Test
  class DummyBox
    attr_accessor :box
    def find(type)
      @box
    end
  end

  def get_sample_size(count = 1)
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stsz")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # sample_size
    io.write_uint32(count) # sample_count
    count.times do |i|
      io.write_uint32(i) # entry_size
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    dummy = DummyBox.new
    dummy.box = box
    dummy
  end

  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("stdp")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint16(1) # priority
    io.write_uint16(2) # priority
    io.write_uint16(3) # priority
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_sample_size(3))
    assert_instance_of(BMFF::Box::DegradationPriority, box)
    assert_equal(size, box.actual_size)
    assert_equal("stdp", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal([1, 2, 3], box.priority)
  end
end
