# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackReferenceType < BMFF::Box::Base
  attr_accessor :track_ids
  register_box "hint", "cdsc", "hind", "vdep", "vplx"

  def parse_data
    super
    @track_ids = []
    until eob?
      @track_ids << io.get_uint32
    end
  end
end
