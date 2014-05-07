# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

module BMFF::BinaryAccessor
  BYTE_ORDER = "\xFE\xFF".unpack("s").first == 0xFEFF ? :be : :le

  # UTF-8, Shift_JIS or ASCII-8BIT (fallback)
  STRING_ENCODINGS = %w(UTF-8 Shift_JIS ASCII-8BIT)

  def get_int8
    _read(1).unpack("c").first
  end

  def write_int8(num)
    expected_int(num, -128, 127)
    write([num].pack("c"))
  end

  def get_uint8
    _read(1).unpack("C").first
  end

  def write_uint8(num)
    expected_int(num, 0, 255)
    write([num].pack("C"))
  end

  def get_int16
    flip_byte_if_needed(_read(2)).unpack("s").first
  end

  def write_int16(num)
    expected_int(num, -32768, 32767)
    write(flip_byte_if_needed([num].pack("s")))
  end

  def get_uint16
    _read(2).unpack("n").first
  end

  def write_uint16(num)
    expected_int(num, 0, 65535)
    write([num].pack("n"))
  end

  def get_uint24
    (get_uint8 << 16) | get_uint16
  end

  def get_int32
    flip_byte_if_needed(_read(4)).unpack("l").first
  end

  def write_int32(num)
    expected_int(num, -2147483648, 2147483647)
    write(flip_byte_if_needed([num].pack("l")))
  end

  def get_uint32
    _read(4).unpack("N").first
  end

  def write_uint32(num)
    expected_int(num, 0, 4294967295)
    write([num].pack("N"))
  end

  def get_int64
    b1 = flip_byte_if_needed(_read(4)).unpack("l").first
    b2 = _read(4).unpack("N").first
    (b1 << 32) | b2
  end

  def write_int64(num)
    expected_int(num, -9223372036854775808, 9223372036854775807)
    b1 = flip_byte_if_needed([num >> 32].pack("l"))
    b2 = [num & 0xFFFFFFFF].pack("N")
    write(b1 + b2)
  end

  def get_uint64
    b1, b2 = _read(8).unpack("N2")
    (b1 << 32) | b2
  end

  def write_uint64(num)
    expected_int(num, 0, 18446744073709551615)
    write([num >> 32, num & 0xFFFFFFFF].pack("N2"))
  end

  def get_ascii(size)
    _read(size).unpack("a*").first
  end

  def write_ascii(ascii)
    raise TypeError unless ascii.kind_of?(String)
    write([ascii].pack("a*"))
  end

  def get_byte(size = 1)
    _read(size)
  end

  def write_byte(byte)
    raise TypeError unless byte.kind_of?(String)
    write(byte)
  end

  # Null-terminated string
  # An encoding of this string is maybe UTF-8.
  # Other encodings are possible.
  # (e.g. Apple Media Handler outputs non UTF-8 string)
  def get_null_terminated_string(max_byte = nil)
    buffer = ""
    read_byte = 0
    until eof?
      b = read(1)
      read_byte += 1
      break if b == "\x00"
      buffer << b
      break if max_byte && read_byte >= max_byte
    end
    STRING_ENCODINGS.each do |encoding|
      buffer.force_encoding(encoding)
      break if buffer.valid_encoding?
    end
    buffer
  end

  def write_null_terminated_string(str)
    raise TypeError unless str.kind_of?(String)
    terminator = str.end_with?("\x00") ? "" : "\x00"
    write(str + terminator)
  end

  # Return ISO 639-2/T code
  # Each character is compressed into 5-bit width.
  # The bit 5 and 6 values are always 1. The bit 7 value is always 0.
  def get_iso639_2_language
    lang = get_uint16
    c1 = (lang >> 10) & 0x1F | 0x60
    c2 = (lang >>  5) & 0x1F | 0x60
    c3 =  lang        & 0x1F | 0x60
    sprintf("%c%c%c", c1, c2, c3)
  end

  def get_uuid
    # TODO: create and return UUID type.
    _read(16)
  end

  private
  def flip_byte_if_needed(data)
    if BYTE_ORDER == :le
      return data.force_encoding("ascii-8bit").reverse
    end
    return data
  end

  def _read(size)
    raise TypeError unless size.kind_of?(Integer)
    raise RangeError if size <= 0
    data = read(size)
    raise EOFError unless data
    raise EOFError unless data.bytesize == size
    data
  end

  def expected_int(val, min, max)
    if val.kind_of?(Integer)
      if val >= min && val <= max
        return true
      else
        raise RangeError
      end
    else
      raise TypeError
    end
  end
end
