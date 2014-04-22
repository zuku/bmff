require 'minitest_helper'
require 'bmff/file_container'

class TestBMFFFileContainer < MiniTest::Unit::TestCase
  def test_initialize
    file_container = BMFF::FileContainer.new
    assert_nil(file_container.boxes)
  end
end
