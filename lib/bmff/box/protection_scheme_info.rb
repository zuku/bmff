# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ProtectionSchemeInfo < BMFF::Box::Base
  attr_accessor :original_format, :scheme_type_box, :info
  register_box "sinf"
  include(BMFF::Box::Container)

  def parse_data
    super
    @original_format = BMFF::Box.get_box(io, self)
    add_child(@original_format)
    unless eob?
      @scheme_type_box = BMFF::Box.get_box(io, self)
      add_child(@scheme_type_box)
      unless eob?
        @info = BMFF::Box.get_box(io, self)
        add_child(@info)
      end
    end
  end
end
