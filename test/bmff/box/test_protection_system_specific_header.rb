# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxProtectionSystemSpecificHeader < MiniTest::Unit::TestCase
  def test_parse_playready
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("uuid")
    io.write_uuid("d08a4f18-10f3-4a82-b6c8-32d8aba183d3") # uuid
    io.write_uint8(0) # version
    io.write_uint24(0) # flags

    io.write_uuid("9a04f079-9840-4286-ab92-e65be0885f95") # system_id (PlayReady)
    io.write_uint32(16) # data_size
    io.write_byte("datadatadatadata") # data

    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ProtectionSystemSpecificHeader, box)
    assert_equal(size, box.actual_size)
    assert_equal("uuid", box.type)
    assert_equal("d08a4f18-10f3-4a82-b6c8-32d8aba183d3", box.usertype.to_s)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal("9a04f079-9840-4286-ab92-e65be0885f95", box.system_id.to_s)
    assert_equal(16, box.data_size)
    assert_equal("datadatadatadata", box.data)
  end
end
