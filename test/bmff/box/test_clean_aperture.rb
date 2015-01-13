# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../../minitest_helper'
require 'bmff/box'
require 'stringio'

class TestBMFFBoxCleanAperture < Minitest::Test
  def test_parse
    io = StringIO.new("", "r+:ascii-8bit")
    io.extend(BMFF::BinaryAccessor)
    io.write_uint32(0)
    io.write_ascii("clap")
    io.write_uint32(160) # clean_aperture_width_n
    io.write_uint32(161) # clean_aperture_width_d
    io.write_uint32(90) # clean_aperture_height_n
    io.write_uint32(91) # clean_aperture_height_d
    io.write_uint32(320) # horiz_off_n
    io.write_uint32(321) # horiz_off_d
    io.write_uint32(180) # vert_off_n
    io.write_uint32(181) # vert_off_d
    size = io.pos
    io.pos = 0
    io.write_uint32(size)
    io.pos = 0

    box = BMFF::Box.get_box(io, nil)
    assert_instance_of(BMFF::Box::CleanAperture, box)
    assert_equal(size, box.actual_size)
    assert_equal("clap", box.type)
    assert_equal(160, box.clean_aperture_width_n)
    assert_equal(161, box.clean_aperture_width_d)
    assert_equal(90, box.clean_aperture_height_n)
    assert_equal(91, box.clean_aperture_height_d)
    assert_equal(320, box.horiz_off_n)
    assert_equal(321, box.horiz_off_d)
    assert_equal(180, box.vert_off_n)
    assert_equal(181, box.vert_off_d)
  end
end
