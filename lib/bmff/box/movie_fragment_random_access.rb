# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::MovieFragmentRandomAccess < BMFF::Box::Base
  register_box "mfra"
  include(BMFF::Box::Container)

  def parse_data
    super
    parse_children
  end
end
