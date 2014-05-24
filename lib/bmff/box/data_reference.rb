# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::DataReference < BMFF::Box::Full
  attr_accessor :entry_count
  register_box "dref"
  include(BMFF::Box::Container)

  def parse_data
    super
    @entry_count = io.get_uint32
    parse_children
  end
end
