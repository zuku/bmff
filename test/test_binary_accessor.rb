# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require 'minitest_helper'
require 'bmff/binary_accessor'
require 'stringio'

class TestBMFFBinaryAccessor < MiniTest::Unit::TestCase
  def test_to_uint8
    io = StringIO.new("\x00\xFF\xF0", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint8)
    assert_equal(255, io.get_uint8)
    assert_equal(240, io.get_uint8)
    assert(io.eof?)
  end
end
