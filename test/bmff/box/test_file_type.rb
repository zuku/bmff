# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxFileType < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("ftyp")
    io.write_ascii("isml") # major_brand
    io.write_uint32(1) # minor_version
    io.write_ascii("piffiso2iso6") # compatible_brands
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::FileType, box)
    assert_equal(size, box.actual_size)
    assert_equal("ftyp", box.type)
    assert_equal("isml", box.major_brand)
    assert_equal(1, box.minor_version)
    assert_equal(%w(piff iso2 iso6), box.compatible_brands)
  end
end
