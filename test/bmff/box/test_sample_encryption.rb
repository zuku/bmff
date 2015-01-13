# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxSampleEncryption < Minitest::Test
  def get_dummy_parent
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    # Track
    io.write_uint32(56)
    io.write_ascii("trak")
    # Track Encryption
    io.write_uint32(48)
    io.write_ascii("uuid")
    io.write_uuid("8974dbce-7be7-4c51-84f9-7148f9882554") # uuid
    io.write_uint8(0) # version
    io.write_uint24(0) # flags

    io.write_uint24(1) # default_algorithm_id
    io.write_uint8(8) # default_iv_size
    io.write_uuid("00010203-0405-0607-0809-0a0b0c0d0e0f") # default_kid
    io.pos = 0
    BMFF::FileContainer.parse(io)
  end

  def test_parse_flags_0
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("uuid")
    io.write_uuid("a2394f52-5a9b-4f14-a244-6c427c648df4") # uuid
    io.write_uint8(0) # version
    io.write_uint24(0) # flags

    io.write_uint32(3) # sample_count
    io.write_byte("01234567") # initialization_vector
    io.write_byte("89ABCDEF") # initialization_vector
    io.write_byte("GHIJKLMN") # initialization_vector

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_dummy_parent)
    assert_instance_of(BMFF::Box::SampleEncryption, box)
    assert_equal(size, box.actual_size)
    assert_equal("uuid", box.type)
    assert_equal("a2394f52-5a9b-4f14-a244-6c427c648df4", box.usertype.to_s)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_nil(box.algorithm_id)
    assert_nil(box.iv_size)
    assert_nil(box.kid)
    assert_equal(3, box.sample_count)
    assert_equal("01234567", box.samples[0].initialization_vector)
    assert_nil(box.samples[0].number_of_entries)
    assert_equal("89ABCDEF", box.samples[1].initialization_vector)
    assert_nil(box.samples[1].number_of_entries)
    assert_equal("GHIJKLMN", box.samples[2].initialization_vector)
    assert_nil(box.samples[2].number_of_entries)
  end

  def test_parse_flags_1
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("uuid")
    io.write_uuid("a2394f52-5a9b-4f14-a244-6c427c648df4") # uuid
    io.write_uint8(0) # version
    io.write_uint24(1) # flags

    io.write_uint24(2) # algorithm_id
    io.write_uint8(16) # iv_size
    io.write_uuid("00010203-0405-0607-0809-0a0b0c0d0e0f") # kid
    io.write_uint32(3) # sample_count
    io.write_byte("0123456789ABCDEF") # initialization_vector
    io.write_byte("GHIJKLMNOPQRSTUV") # initialization_vector
    io.write_byte("WXYZabcdefghijkl") # initialization_vector

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::SampleEncryption, box)
    assert_equal(size, box.actual_size)
    assert_equal("uuid", box.type)
    assert_equal("a2394f52-5a9b-4f14-a244-6c427c648df4", box.usertype.to_s)
    assert_equal(0, box.version)
    assert_equal(1, box.flags)
    assert_equal(2, box.algorithm_id)
    assert_equal(16, box.iv_size)
    assert_equal("00010203-0405-0607-0809-0a0b0c0d0e0f", box.kid.to_s)
    assert_equal(3, box.sample_count)
    assert_equal("0123456789ABCDEF", box.samples[0].initialization_vector)
    assert_nil(box.samples[0].number_of_entries)
    assert_equal("GHIJKLMNOPQRSTUV", box.samples[1].initialization_vector)
    assert_nil(box.samples[1].number_of_entries)
    assert_equal("WXYZabcdefghijkl", box.samples[2].initialization_vector)
    assert_nil(box.samples[2].number_of_entries)
  end

  def test_parse_flags_2
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("uuid")
    io.write_uuid("a2394f52-5a9b-4f14-a244-6c427c648df4") # uuid
    io.write_uint8(0) # version
    io.write_uint24(2) # flags

    io.write_uint32(3) # sample_count
    io.write_byte("01234567") # initialization_vector
    io.write_uint16(3) # number_of_entries
    io.write_uint16(255) # bytes_of_clear_data
    io.write_uint32(16777215) # bytes_of_encrypted_data
    io.write_uint16(4095) # bytes_of_clear_data
    io.write_uint32(268435455) # bytes_of_encrypted_data
    io.write_uint16(65535) # bytes_of_clear_data
    io.write_uint32(4294967295) # bytes_of_encrypted_data

    io.write_byte("89ABCDEF") # initialization_vector
    io.write_uint16(2) # number_of_entries
    io.write_uint16(255) # bytes_of_clear_data
    io.write_uint32(16777215) # bytes_of_encrypted_data
    io.write_uint16(4095) # bytes_of_clear_data
    io.write_uint32(268435455) # bytes_of_encrypted_data

    io.write_byte("GHIJKLMN") # initialization_vector
    io.write_uint16(1) # number_of_entries
    io.write_uint16(255) # bytes_of_clear_data
    io.write_uint32(16777215) # bytes_of_encrypted_data

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, get_dummy_parent)
    assert_instance_of(BMFF::Box::SampleEncryption, box)
    assert_equal(size, box.actual_size)
    assert_equal("uuid", box.type)
    assert_equal("a2394f52-5a9b-4f14-a244-6c427c648df4", box.usertype.to_s)
    assert_equal(0, box.version)
    assert_equal(2, box.flags)
    assert_nil(box.algorithm_id)
    assert_nil(box.iv_size)
    assert_nil(box.kid)
    assert_equal(3, box.sample_count)
    assert_equal("01234567", box.samples[0].initialization_vector)
    assert_equal(3, box.samples[0].number_of_entries)
    assert_equal(3, box.samples[0].entries.count)
    assert_equal(255, box.samples[0].entries[0].bytes_of_clear_data)
    assert_equal(16777215, box.samples[0].entries[0].bytes_of_encrypted_data)
    assert_equal(4095, box.samples[0].entries[1].bytes_of_clear_data)
    assert_equal(268435455, box.samples[0].entries[1].bytes_of_encrypted_data)
    assert_equal(65535, box.samples[0].entries[2].bytes_of_clear_data)
    assert_equal(4294967295, box.samples[0].entries[2].bytes_of_encrypted_data)
    assert_equal("89ABCDEF", box.samples[1].initialization_vector)
    assert_equal(2, box.samples[1].number_of_entries)
    assert_equal(2, box.samples[1].entries.count)
    assert_equal(255, box.samples[1].entries[0].bytes_of_clear_data)
    assert_equal(16777215, box.samples[1].entries[0].bytes_of_encrypted_data)
    assert_equal(4095, box.samples[1].entries[1].bytes_of_clear_data)
    assert_equal(268435455, box.samples[1].entries[1].bytes_of_encrypted_data)
    assert_equal("GHIJKLMN", box.samples[2].initialization_vector)
    assert_equal(1, box.samples[2].number_of_entries)
    assert_equal(1, box.samples[2].entries.count)
    assert_equal(255, box.samples[2].entries[0].bytes_of_clear_data)
    assert_equal(16777215, box.samples[2].entries[0].bytes_of_encrypted_data)
  end
end
