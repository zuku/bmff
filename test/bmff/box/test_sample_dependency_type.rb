# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSampleDependencyType < MiniTest::Unit::TestCase
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
    io.write_ascii("sdtp")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    # is_leading (0), sample_depends_on (1), sample_is_depended_on (2), sample_has_redundancy (3)
    io.write_uint8(27)
    # is_leading (1), sample_depends_on (2), sample_is_depended_on (3), sample_has_redundancy (0)
    io.write_uint8(108)
    # is_leading (2), sample_depends_on (3), sample_is_depended_on (0), sample_has_redundancy (1)
    io.write_uint8(177)
    # is_leading (3), sample_depends_on (0), sample_is_depended_on (1), sample_has_redundancy (2)
    io.write_uint8(198)
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_sample_size(4))
    assert_instance_of(BMFF::Box::SampleDependencyType, box)
    assert_equal(size, box.actual_size)
    assert_equal("sdtp", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal([0, 1, 2, 3], box.is_leading)
    assert_equal([1, 2, 3, 0], box.sample_depends_on)
    assert_equal([2, 3, 0, 1], box.sample_is_depended_on)
    assert_equal([3, 0, 1, 2], box.sample_has_redundancy)
  end
end
