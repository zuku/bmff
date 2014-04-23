# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ProgressiveDownloadInfo < BMFF::Box::Full
  attr_accessor :information
  register_box "pdin"

  def parse_data
    super
    @information = []
    until eob?
      @information << {:rate => io.get_uint32,
                       :initial_delay => io.get_uint32}
    end
  end
end
