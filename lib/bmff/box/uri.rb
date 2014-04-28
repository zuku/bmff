# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::URI < BMFF::Box::Full
  attr_accessor :theuri
  register_box "uri "

  def parse_data
    super
    @theuri = io.get_null_terminated_string
  end
end
