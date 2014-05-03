# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::DataEntryUrn < BMFF::Box::Full
  attr_accessor :name, :location
  register_box "urn "

  def parse_data
    super
    @name = io.get_null_terminated_string
    @location = io.get_null_terminated_string
  end
end
