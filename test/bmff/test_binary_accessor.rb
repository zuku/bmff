# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../minitest_helper'
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

  def test_write_int8
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_int8(0)
    io.write_int8(127)
    io.write_int8(-1)
    io.write_int8(-128)
    io.pos = 0
    assert_equal("\x00\x7F\xFF\x80", io.read)
  end

  def test_write_int8_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_int8(128)
    end
    assert_raises(RangeError) do
      io.write_int8(-129)
    end
  end

  def test_write_int8_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_int8(0.1)
    end
    assert_raises(TypeError) do
      io.write_int8(nil)
    end
    assert_raises(TypeError) do
      io.write_int8("0")
    end
    assert_raises(TypeError) do
      io.write_int8(true)
    end
    assert_raises(TypeError) do
      io.write_int8(false)
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

  def test_write_uint8
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint8(0)
    io.write_uint8(255)
    io.pos = 0
    assert_equal("\x00\xFF", io.read)
  end

  def test_write_uint8_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_uint8(256)
    end
    assert_raises(RangeError) do
      io.write_uint8(-1)
    end
  end

  def test_write_uint8_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_uint8(0.1)
    end
    assert_raises(TypeError) do
      io.write_uint8(nil)
    end
    assert_raises(TypeError) do
      io.write_uint8("0")
    end
    assert_raises(TypeError) do
      io.write_uint8(true)
    end
    assert_raises(TypeError) do
      io.write_uint8(false)
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

  def test_write_int16
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_int16(32767)
    io.write_int16(255)
    io.write_int16(-1)
    io.write_int16(-32768)
    io.pos = 0
    assert_equal("\x7F\xFF\x00\xFF\xFF\xFF\x80\x00", io.read)
  end

  def test_write_int16_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_int16(32768)
    end
    assert_raises(RangeError) do
      io.write_int16(-32769)
    end
  end

  def test_write_int16_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_int16(0.1)
    end
    assert_raises(TypeError) do
      io.write_int16(nil)
    end
    assert_raises(TypeError) do
      io.write_int16("0")
    end
    assert_raises(TypeError) do
      io.write_int16(true)
    end
    assert_raises(TypeError) do
      io.write_int16(false)
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

  def test_write_uint16
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint16(0)
    io.write_uint16(255)
    io.write_uint16(65535)
    io.pos = 0
    assert_equal("\x00\x00\x00\xFF\xFF\xFF", io.read)
  end

  def test_write_uint16_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_uint16(65536)
    end
    assert_raises(RangeError) do
      io.write_uint16(-1)
    end
  end

  def test_write_uint16_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_uint16(0.1)
    end
    assert_raises(TypeError) do
      io.write_uint16(nil)
    end
    assert_raises(TypeError) do
      io.write_uint16("0")
    end
    assert_raises(TypeError) do
      io.write_uint16(true)
    end
    assert_raises(TypeError) do
      io.write_uint16(false)
    end
  end

  def test_get_uint24
    io = StringIO.new("\x00\x00\x00\xFF\xFF\xFF", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal(0, io.get_uint24)
    assert_equal(16777215, io.get_uint24)
    assert(io.eof?)
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

  def test_write_int32
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_int32(0)
    io.write_int32(-1)
    io.write_int32(-2147483648)
    io.pos = 0
    assert_equal("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", io.read)
  end

  def test_write_int32_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_int32(2147483648)
    end
    assert_raises(RangeError) do
      io.write_int32(-2147483649)
    end
  end

  def test_write_int32_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_int32(0.1)
    end
    assert_raises(TypeError) do
      io.write_int32(nil)
    end
    assert_raises(TypeError) do
      io.write_int32("0")
    end
    assert_raises(TypeError) do
      io.write_int32(true)
    end
    assert_raises(TypeError) do
      io.write_int32(false)
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

  def test_write_uint32
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_uint32(4294967295)
    io.write_uint32(2147483648)
    io.pos = 0
    assert_equal("\x00\x00\x00\x00\xFF\xFF\xFF\xFF\x80\x00\x00\x00", io.read)
  end

  def test_write_uint32_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_uint32(4294967296)
    end
    assert_raises(RangeError) do
      io.write_uint32(-1)
    end
  end

  def test_write_uint32_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_uint32(0.1)
    end
    assert_raises(TypeError) do
      io.write_uint32(nil)
    end
    assert_raises(TypeError) do
      io.write_uint32("0")
    end
    assert_raises(TypeError) do
      io.write_uint32(true)
    end
    assert_raises(TypeError) do
      io.write_uint32(false)
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

  def test_write_int64
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_int64(0)
    io.write_int64(-1)
    io.write_int64(-9223372036854775808)
    io.pos = 0
    assert_equal("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                 "\x80\x00\x00\x00\x00\x00\x00\x00", io.read)
  end

  def test_write_int64_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_int64(9223372036854775808)
    end
    assert_raises(RangeError) do
      io.write_int64(-9223372036854775809)
    end
  end

  def test_write_int64_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_int64(0.1)
    end
    assert_raises(TypeError) do
      io.write_int64(nil)
    end
    assert_raises(TypeError) do
      io.write_int64("0")
    end
    assert_raises(TypeError) do
      io.write_int64(true)
    end
    assert_raises(TypeError) do
      io.write_int64(false)
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

  def test_write_uint64
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint64(0)
    io.write_uint64(18446744073709551615)
    io.write_uint64(9223372036854775808)
    io.pos = 0
    assert_equal("\x00\x00\x00\x00\x00\x00\x00\x00" + "\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF" +
                 "\x80\x00\x00\x00\x00\x00\x00\x00", io.read)
  end

  def test_write_uint64_out_of_range
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.write_uint64(18446744073709551616)
    end
    assert_raises(RangeError) do
      io.write_uint64(-1)
    end
  end

  def test_write_uint64_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_uint64(0.1)
    end
    assert_raises(TypeError) do
      io.write_uint64(nil)
    end
    assert_raises(TypeError) do
      io.write_uint64("0")
    end
    assert_raises(TypeError) do
      io.write_uint64(true)
    end
    assert_raises(TypeError) do
      io.write_uint64(false)
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

  def test_get_ascii_out_of_range
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.get_ascii(0)
    end
    assert_raises(RangeError) do
      io.get_ascii(-1)
    end
  end

  def test_get_ascii_invalid_size
    io = StringIO.new("abc", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.get_ascii(1.0)
    end
    assert_raises(TypeError) do
      io.get_ascii(nil)
    end
    assert_raises(TypeError) do
      io.get_ascii("1")
    end
    assert_raises(TypeError) do
      io.get_ascii(true)
    end
    assert_raises(TypeError) do
      io.get_ascii(false)
    end
  end

  def test_write_ascii
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_ascii("")
    io.write_ascii("a")
    io.write_ascii("n\x00")
    io.write_ascii("xyz")
    io.pos = 0
    assert_equal("an\x00xyz", io.read)
  end

  def test_write_ascii_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_ascii(0.1)
    end
    assert_raises(TypeError) do
      io.write_ascii(nil)
    end
    assert_raises(TypeError) do
      io.write_ascii(0)
    end
    assert_raises(TypeError) do
      io.write_ascii(true)
    end
    assert_raises(TypeError) do
      io.write_ascii(false)
    end
  end

  def test_get_byte
    io = StringIO.new("\x00\x01\x02\x03\x04\x05\x06\x07\xFF\xFE\xFD\xFC\xFB\xFA\xF9\xF8", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("\x00".force_encoding("ascii-8bit"), io.get_byte)
    assert_equal("\x01\x02".force_encoding("ascii-8bit"), io.get_byte(2))
    assert_equal("\x03\x04\x05".force_encoding("ascii-8bit"), io.get_byte(3))
    assert_equal("\x06\x07\xFF\xFE".force_encoding("ascii-8bit"), io.get_byte(4))
    assert_equal("\xFD\xFC\xFB\xFA\xF9".force_encoding("ascii-8bit"), io.get_byte(5))
    assert_equal("\xF8".force_encoding("ascii-8bit"), io.get_byte)
    assert(io.eof?)
  end

  def test_get_byte_insufficient_data
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_byte(3)
    end
  end

  def test_get_byte_out_of_range
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(RangeError) do
      io.get_byte(0)
    end
    assert_raises(RangeError) do
      io.get_byte(-1)
    end
  end

  def test_get_byte_invalid_size
    io = StringIO.new("\x00\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.get_byte(1.0)
    end
    assert_raises(TypeError) do
      io.get_byte(nil)
    end
    assert_raises(TypeError) do
      io.get_byte("1")
    end
    assert_raises(TypeError) do
      io.get_byte(true)
    end
    assert_raises(TypeError) do
      io.get_byte(false)
    end
  end

  def test_write_byte
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_byte("")
    io.write_byte("\xFF\xFE\xFD")
    io.write_byte("\x00\x01\x02\x03")
    io.pos = 0
    assert_equal("\xFF\xFE\xFD\x00\x01\x02\x03", io.read)
  end

  def test_write_byte_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_byte(0.1)
    end
    assert_raises(TypeError) do
      io.write_byte(nil)
    end
    assert_raises(TypeError) do
      io.write_byte(0)
    end
    assert_raises(TypeError) do
      io.write_byte(true)
    end
    assert_raises(TypeError) do
      io.write_byte(false)
    end
  end

  def test_null_terminated_string_utf8
    io = StringIO.new("ABCDEFG \xC3\x80\xC3\x81 \xE3\xBF\xB0\xE3\xBF\xB1\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string
    assert_equal(Encoding::UTF_8, actual.encoding)
    assert_equal("ABCDEFG ÀÁ 㿰㿱", actual)
    assert(io.eof?)
  end

  def test_null_terminated_string_shift_jis
    io = StringIO.new("\x41\x42\x43\x44\x45\x46\x47\x20\x82\x60\x82\x61\x20\x82\xF0\x82\xF1\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string
    assert_equal(Encoding::Shift_JIS, actual.encoding)
    assert_equal("ABCDEFG ＡＢ をん", actual.encode("UTF-8"))
    assert(io.eof?)
  end

  def test_null_terminated_string_unknown_encoding
    io = StringIO.new("\x41\x42\x43\x44\x45\x46\x47\x20\xA3\xC1\xA3\xC2\x20\xA4\xF2\xA4\xF3\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string
    assert_equal(Encoding::ASCII_8BIT, actual.encoding)
    assert_equal("\x41\x42\x43\x44\x45\x46\x47\x20\xA3\xC1\xA3\xC2\x20\xA4\xF2\xA4\xF3".force_encoding("ASCII-8BIT"), actual.encode)
    assert(io.eof?)
  end

  def test_null_terminated_string_with_max_byte
    io = StringIO.new("ABCDEFGHIJKLMNOPQRSTUVWXYZ\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string(27)
    assert_equal(Encoding::UTF_8, actual.encoding)
    assert_equal("ABCDEFGHIJKLMNOPQRSTUVWXYZ", actual)
    assert(io.eof?)
  end

  def test_null_terminated_string_with_max_byte_long
    io = StringIO.new("ABCDEFGHIJKLMNOPQRSTUVWXYZ\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string(30)
    assert_equal(Encoding::UTF_8, actual.encoding)
    assert_equal("ABCDEFGHIJKLMNOPQRSTUVWXYZ", actual)
    assert(io.eof?)
  end

  def test_null_terminated_string_with_max_byte_short
    io = StringIO.new("ABCDEFGHIJKLMNOPQRSTUVWXYZ\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string(16)
    assert_equal(Encoding::UTF_8, actual.encoding)
    assert_equal("ABCDEFGHIJKLMNOP", actual)
    assert(!io.eof?)
  end

  def test_null_terminated_string_is_not_terminated
    io = StringIO.new("ABCDEFGHIJKLMNOPQRSTUVWXYZ", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    actual = io.get_null_terminated_string
    assert_equal(Encoding::UTF_8, actual.encoding)
    assert_equal("ABCDEFGHIJKLMNOPQRSTUVWXYZ", actual)
    assert(io.eof?)
  end

  def test_write_null_terminated_string
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_null_terminated_string("ABCDEFG ÀÁ 㿰㿱")
    io.write_null_terminated_string("À\x00")
    io.pos = 0
    assert_equal("ABCDEFG \xC3\x80\xC3\x81 \xE3\xBF\xB0\xE3\xBF\xB1\x00\xC3\x80\x00", io.read)
  end

  def test_write_null_terminated_string_invalid_value
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(TypeError) do
      io.write_null_terminated_string(0.1)
    end
    assert_raises(TypeError) do
      io.write_null_terminated_string(nil)
    end
    assert_raises(TypeError) do
      io.write_null_terminated_string(0)
    end
    assert_raises(TypeError) do
      io.write_null_terminated_string(true)
    end
    assert_raises(TypeError) do
      io.write_null_terminated_string(false)
    end
  end

  def test_get_iso639_2_language
    io = StringIO.new("\x15\xC7", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("eng", io.get_iso639_2_language)
    assert(io.eof?)
  end

  def test_iso639_2_language_insufficient_data
    io = StringIO.new("\x00", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_raises(EOFError) do
      io.get_iso639_2_language
    end
  end

  def test_get_uuid
    io = StringIO.new("\x00\x01\x02\x03\x04\x05\x06\x07\x80\x90\xA0\xB0\xC0\xD0\xE0\xF0", "r:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    assert_equal("\x00\x01\x02\x03\x04\x05\x06\x07\x80\x90\xA0\xB0\xC0\xD0\xE0\xF0".force_encoding("ascii-8bit"), io.get_uuid)
    assert(io.eof?)
  end

end
