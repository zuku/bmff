# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::TrackEncryption < BMFF::Box::Full
  attr_accessor :default_algorithm_id, :default_iv_size, :default_kid
  register_uuid_box "8974dbce-7be7-4c51-84f9-7148f9882554"

  def parse_data
    super
    @default_algorithm_id = io.get_uint24
    @default_iv_size = io.get_uint8
    @default_kid = io.get_uuid
  end
end
