# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxOriginalFormat < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("frma")
    io.write_ascii("mp4v") # data_format
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::OriginalFormat, box)
    assert_equal(size, box.actual_size)
    assert_equal("frma", box.type)
    assert_equal("mp4v", box.data_format)
  end
end
