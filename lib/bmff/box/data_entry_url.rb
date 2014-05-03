# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::DataEntryUrl < BMFF::Box::Full
  attr_accessor :location
  register_box "url "

  def parse_data
    super
    @location = io.get_null_terminated_string
  end
end
