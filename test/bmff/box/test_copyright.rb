# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxCopyright < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("cprt")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_byte("\x15\xC7") # language (eng)
    io.write_null_terminated_string("Copyright (c)") # notice
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::Copyright, box)
    assert_equal(size, box.actual_size)
    assert_equal("cprt", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal("eng", box.language)
    assert_equal("Copyright (c)", box.notice)
  end

  def test_parse_without_notice
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("cprt")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_byte("\x2A\x0E") # language (jpn)
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::Copyright, box)
    assert_equal(size, box.actual_size)
    assert_equal("cprt", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal("jpn", box.language)
    assert_nil(box.notice)
  end
end
