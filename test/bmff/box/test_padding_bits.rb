# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxPaddingBits < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("padb")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(3) # sample_count
    # sample
    2.times do |i|
      io.write_uint8(118) # reserved1, pad1, reserved2, pad2
    end
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::PaddingBits, box)
    assert_equal(size, box.actual_size)
    assert_equal("padb", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(3, box.sample_count)
    assert_equal([false, false], box.reserved1)
    assert_equal([7, 7], box.pad1)
    assert_equal([false, false], box.reserved2)
    assert_equal([6, 6], box.pad2)
  end
end
