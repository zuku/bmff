# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxAudioSampleEntry < MiniTest::Unit::TestCase
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("mp4a")
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint8(0) # reserved1
    io.write_uint16(1) # data_reference_index
    io.write_uint32(0) # reserved2
    io.write_uint32(0) # reserved2
    io.write_uint16(2) # channelcount
    io.write_uint16(16) # samplesize
    io.write_uint16(0) # pre_defined
    io.write_uint16(0) # reserved3
    io.write_uint32(2890137600) # samplerate
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil, BMFF::Box::AudioSampleEntry)
    assert_instance_of(BMFF::Box::AudioSampleEntry, box)
    assert_equal(size, box.actual_size)
    assert_equal("mp4a", box.type)
    assert_equal([0, 0, 0, 0, 0, 0], box.reserved1)
    assert_equal(1, box.data_reference_index)
    assert_equal([0, 0], box.reserved2)
    assert_equal(2, box.channelcount)
    assert_equal(16, box.samplesize)
    assert_equal(0, box.pre_defined)
    assert_equal(0, box.reserved3)
    assert_equal(2890137600, box.samplerate)
  end
end
