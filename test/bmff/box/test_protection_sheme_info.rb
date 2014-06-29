# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxProtectionSchemeInfo < MiniTest::Unit::TestCase
  def test_parse_only_original_format
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("sinf")

    # original_format
    io.write_uint32(12)
    io.write_ascii("frma")
    io.write_ascii("mp4v") # data_format

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ProtectionSchemeInfo, box)
    assert_equal(size, box.actual_size)
    assert_equal("sinf", box.type)
    assert_instance_of(BMFF::Box::OriginalFormat, box.original_format)
    assert_equal("mp4v", box.original_format.data_format)
    assert_equal(1, box.children.count)
    assert_nil(box.scheme_type_box)
    assert_nil(box.info)
    assert(box.container?)
  end

  def test_parse_with_scheme_type_info
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("sinf")

    # original_format
    io.write_uint32(12)
    io.write_ascii("frma")
    io.write_ascii("mp4v") # data_format

    # scheme_type_box
    io.write_uint32(20)
    io.write_ascii("schm")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_ascii("abcd") # scheme_type
    io.write_uint32(1) # scheme_version

    # info
    io.write_uint32(8)
    io.write_ascii("schi")

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ProtectionSchemeInfo, box)
    assert_equal(size, box.actual_size)
    assert_equal("sinf", box.type)

    assert_instance_of(BMFF::Box::OriginalFormat, box.original_format)
    assert_equal("mp4v", box.original_format.data_format)

    assert_instance_of(BMFF::Box::SchemeType, box.scheme_type_box)
    assert_equal("abcd", box.scheme_type_box.scheme_type)
    assert_equal(1, box.scheme_type_box.scheme_version)

    assert_instance_of(BMFF::Box::SchemeInformation, box.info)

    assert_equal(3, box.children.count)
    assert(box.container?)
  end
end
