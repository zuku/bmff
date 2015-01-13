# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSchemeType < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("schm")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_ascii("abcd") # scheme_type
    io.write_uint32(1) # scheme_version
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SchemeType, box)
    assert_equal(size, box.actual_size)
    assert_equal("schm", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal("abcd", box.scheme_type)
    assert_equal(1, box.scheme_version)
    assert_nil(box.scheme_url)
  end

  def test_parse_with_scheme_url
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("schm")
    io.write_uint8(0) # version
    io.write_uint24(1) # flags
    io.write_ascii("abcd") # scheme_type
    io.write_uint32(1) # scheme_version
    io.write_null_terminated_string("http://example.com/") # scheme_url
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SchemeType, box)
    assert_equal(size, box.actual_size)
    assert_equal("schm", box.type)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal("abcd", box.scheme_type)
    assert_equal(1, box.scheme_version)
    assert_equal("http://example.com/", box.scheme_url)
  end
end
