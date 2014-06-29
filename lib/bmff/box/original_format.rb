# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::OriginalFormat < BMFF::Box::Base
  attr_accessor :data_format
  register_box "frma"

  def parse_data
    super
    @data_format = io.get_ascii(4)
  end
end
