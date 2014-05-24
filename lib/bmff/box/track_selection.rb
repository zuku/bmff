# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackSelection < BMFF::Box::Full
  attr_accessor :switch_group, :attribute_list
  register_box "tsel"

  def parse_data
    super
    @switch_group = io.get_int32
    @attribute_list = []
    until eob?
      @attribute_list << io.get_ascii(4)
    end
  end
end
