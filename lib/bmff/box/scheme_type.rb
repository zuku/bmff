# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SchemeType < BMFF::Box::Full
  attr_accessor :scheme_type, :scheme_version, :scheme_url
  register_box "schm"

  def parse_data
    super
    @scheme_type = io.get_ascii(4)
    @scheme_version = io.get_uint32
    if @flags & 0x01 > 0
      @scheme_url = io.get_null_terminated_string
    end
  end
end
