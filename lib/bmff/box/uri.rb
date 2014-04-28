# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::URI < BMFF::Box::Full
  attr_accessor :the_uri
  register_box "uri "

  def parse_data
    super
    @the_uri = io.get_null_terminated_string
  end
end
