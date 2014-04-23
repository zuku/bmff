# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

require_relative '../minitest_helper'
require 'bmff/file_container'

class TestBMFFFileContainer < MiniTest::Unit::TestCase
  SAMPLE_FILE_COMMON_MP4 = 'bmff.mp4'

  def get_sample_file_path(file_name)
    return File.join(File.expand_path('../../assets', __FILE__), file_name)
  end

  def test_parse
    open(get_sample_file_path(SAMPLE_FILE_COMMON_MP4), "rb:ascii-8bit") do |f|
      file_container = BMFF::FileContainer.parse(f)
      assert_kind_of(BMFF::FileContainer, file_container)
      assert_kind_of(Array, file_container.boxes)
      assert_equal(5, file_container.boxes.count)
      assert_instance_of(BMFF::Box::FileType, file_container.boxes[0])
      assert_instance_of(BMFF::Box::Unknown, file_container.boxes[1])
      assert_instance_of(BMFF::Box::FreeSpace, file_container.boxes[2])
      assert_instance_of(BMFF::Box::FreeSpace, file_container.boxes[3])
      assert_instance_of(BMFF::Box::MediaData, file_container.boxes[4])
    end
  end
end
