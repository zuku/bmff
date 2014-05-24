# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxProgressiveDownloadInfo < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("pdin")
    io.write_uint8(0) # version
    io.write_uint24(0) # flags
    io.write_uint32(0) # rate
    io.write_uint32(0) # initial_delay
    io.write_uint32(255) # rate
    io.write_uint32(65535) # initial_delay
    io.write_uint32(16777215) # rate
    io.write_uint32(4294967295) # initial_delay
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::ProgressiveDownloadInfo, box)
    assert_equal(size, box.actual_size)
    assert_equal("pdin", box.type)
    assert_equal(0, box.version)
    assert_equal(0, box.flags)
    assert_equal([0, 255, 16777215], box.rate)
    assert_equal([0, 65535, 4294967295], box.initial_delay)
  end
end
