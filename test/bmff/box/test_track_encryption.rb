# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxTrackEncryption < Minitest::Test
  def test_parse_flags_0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("uuid")
    io.write_uuid("8974dbce-7be7-4c51-84f9-7148f9882554") # uuid
    io.write_uint8(0) # version
    io.write_uint24(0) # flags

    io.write_uint24(1) # default_algorithm_id
    io.write_uint8(8) # default_iv_size
    io.write_uuid("00010203-0405-0607-0809-0a0b0c0d0e0f") # default_kid

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackEncryption, box)
    assert_equal(size, box.actual_size)
    assert_equal("uuid", box.type)
    assert_equal("8974dbce-7be7-4c51-84f9-7148f9882554", box.usertype.to_s)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.default_algorithm_id)
    assert_equal(8, box.default_iv_size)
    assert_equal("00010203-0405-0607-0809-0a0b0c0d0e0f", box.default_kid.to_s)
  end

  def test_parse_tenc_box
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("tenc")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags

    io.write_uint24(1) # default_is_encrypted
    io.write_uint8(8) # default_iv_size
    io.write_uuid("00010203-0405-0607-0809-0a0b0c0d0e0f") # default_kid

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::TrackEncryption, box)
    assert_equal(size, box.actual_size)
    assert_equal("tenc", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal(1, box.default_is_encrypted)
    assert_equal(8, box.default_iv_size)
    assert_equal("00010203-0405-0607-0809-0a0b0c0d0e0f", box.default_kid.to_s)
  end
end
