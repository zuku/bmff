# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxBase < Minitest::Test
  def test_parse_largesize
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(1)
    io.write_ascii("xxxx")
    io.write_uint64(16)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_equal(16, box.actual_size)
    assert_equal(1, box.size)
    assert_equal(16, box.largesize)
    assert_equal("xxxx", box.type)
  end

  def test_parse_eof_size
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("xxxx")
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_nil(box.actual_size)
    assert_equal(0, box.size)
    assert_nil(box.largesize)
    assert_equal("xxxx", box.type)
  end
end
