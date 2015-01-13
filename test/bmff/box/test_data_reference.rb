# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxDataReference < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("dref")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(2) # entry_count
    # DataEntryUrn
    io.write_uint32(29) # size
    io.write_ascii("urn ") # type
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_null_terminated_string("bmff") # name
    io.write_null_terminated_string("urn:example") # location
    # DataEntryUrl
    io.write_uint32(32) # size
    io.write_ascii("url ") # type
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_null_terminated_string("http://example.com/") # location
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::DataReference, box)
    assert_equal(size, box.actual_size)
    assert_equal("dref", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(2, box.entry_count)

    assert_instance_of(BMFF::Box::DataEntryUrn, box.children[0])
    assert_equal(29, box.children[0].actual_size)
    assert_equal("urn ", box.children[0].type)
    assert_equal(0, box.children[0].version)
    assert_equal(0, box.children[0].flags)
    assert_equal("bmff", box.children[0].name)
    assert_equal("urn:example", box.children[0].location)

    assert_instance_of(BMFF::Box::DataEntryUrl, box.children[1])
    assert_equal(32, box.children[1].actual_size)
    assert_equal("url ", box.children[1].type)
    assert_equal(0, box.children[1].version)
    assert_equal(0, box.children[1].flags)
    assert_equal("http://example.com/", box.children[1].location)
  end
end
