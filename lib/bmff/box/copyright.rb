# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Copyright < BMFF::Box::Full
  attr_accessor :language, :notice
  register_box "cprt"

  def parse_data
    super
    @language = io.get_iso639_2_language
    @notice = io.get_null_terminated_string unless eob?
  end
end
