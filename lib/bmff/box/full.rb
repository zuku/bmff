# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Full < BMFF::Box::Base
  attr_accessor :version, :flags
  def parse_data
    super
    @version = io.get_uint8
    @flags = io.get_byte(3)
  end
end
