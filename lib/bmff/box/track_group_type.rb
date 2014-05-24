# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackGroupType < BMFF::Box::Full
  attr_accessor :track_group_id
  register_box "msrc"

  def parse_data
    super
    @track_group_id = io.get_uint32
  end
end
