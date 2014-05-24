# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxHandler < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hdlr")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # pre_defined
    io.write_ascii("vide") # handler_type
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    io.write_null_terminated_string("bmff test") # name
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::Handler, box)
    assert_equal(size, box.actual_size)
    assert_equal("hdlr", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.pre_defined)
    assert_equal("vide", box.handler_type)
    assert_equal([0, 0, 0], box.reserved1)
    assert_equal("bmff test", box.name)
  end

  def test_parse_without_name
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("hdlr")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # pre_defined
    io.write_ascii("vide") # handler_type
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    io.write_uint32(0) # reserved1
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::Handler, box)
    assert_equal(size, box.actual_size)
    assert_equal("hdlr", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(0, box.pre_defined)
    assert_equal("vide", box.handler_type)
    assert_equal([0, 0, 0], box.reserved1)
    assert_nil(box.name)
  end
end
