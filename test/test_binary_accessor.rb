# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require 'minitest_helper'
require 'bmff/binary_accessor'
require 'stringio'

class TestBMFFBinaryAccessor < MiniTest::Unit::TestCase
  def test_get_int8
    io = StringIO.new("\x00\xFF\x80", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int8)
    assert_equal(-1, io.get_int8)
    assert_equal(-128, io.get_int8)
    assert(io.eof?)
  end

  def test_get_int8_insufficient_data
    io = StringIO.new("", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int8
    end
  end

  def test_get_uint8
    io = StringIO.new("\x00\xFF\xF0", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint8)
    assert_equal(255, io.get_uint8)
    assert_equal(240, io.get_uint8)
    assert(io.eof?)
  end

  def test_get_uint8_insufficient_data
    io = StringIO.new("", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint8
    end
  end

  def test_get_int16
    io = StringIO.new("\x00\xFF\xFF\xFF\x80\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(255, io.get_int16)
    assert_equal(-1, io.get_int16)
    assert_equal(-32768, io.get_int16)
    assert(io.eof?)
  end

  def test_get_int16_insufficient_data
    io = StringIO.new("\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int16
    end
  end

  def test_get_uint16
    io = StringIO.new("\x00\xFF\xFF\xFF", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(255, io.get_uint16)
    assert_equal(65535, io.get_uint16)
    assert(io.eof?)
  end

  def test_get_uint16_insufficient_data
    io = StringIO.new("\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint16
    end
  end

  def test_get_int32
    io = StringIO.new("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int32)
    assert_equal(-1, io.get_int32)
    assert_equal(-2147483648, io.get_int32)
    assert(io.eof?)
  end

  def test_get_int32_insufficient_data
    io = StringIO.new("\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int32
    end
  end

  def test_get_uint32
    io = StringIO.new("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint32)
    assert_equal(4294967295, io.get_uint32)
    assert_equal(2147483648, io.get_uint32)
    assert(io.eof?)
  end

  def test_get_uint32_insufficient_data
    io = StringIO.new("\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint32
    end
  end

  def test_get_int64
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                      "\x80\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_int64)
    assert_equal(-1, io.get_int64)
    assert_equal(-9223372036854775808, io.get_int64)
    assert(io.eof?)
  end

  def test_get_int64_insufficient_data
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_int64
    end
  end

  def test_get_uint64
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                      "\x80\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint64)
    assert_equal(18446744073709551615, io.get_uint64)
    assert_equal(9223372036854775808, io.get_uint64)
    assert(io.eof?)
  end

  def test_get_uint64_insufficient_data
    io = StringIO.new("\x00\x00\x00\x00\x00\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_uint64
    end
  end

  def test_get_ascii
    io = StringIO.new("abcdefgh", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("abcd", io.get_ascii(4))
    assert_equal("efgh", io.get_ascii(4))
    assert(io.eof?)
  end

  def test_get_ascii_null_terminated
    io = StringIO.new("ab\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("ab\x00\x00", io.get_ascii(4))
    assert(io.eof?)
  end

  def test_get_ascii_insufficient_data
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_ascii(4)
    end
  end
end
