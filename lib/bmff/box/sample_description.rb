# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleDescription < BMFF::Box::Full
  attr_accessor :entry_count
  register_box "stsd"
  include(BMFF::Box::Container)

  def parse_data
    super
    @children = []
    @entry_count = io.get_uint32
    if handler = parent.parent.parent.find(BMFF::Box::Handler)
      @entry_count.times do
        case handler.handler_type
        when "soun"
          @children << BMFF::Box.get_box(io, self, BMFF::Box::AudioSampleEntry)
        when "vide"
          @children << BMFF::Box.get_box(io, self, BMFF::Box::VisualSampleEntry)
        when "hint"
          @children << BMFF::Box.get_box(io, self, BMFF::Box::HintSampleEntry)
        when "meta"
          @children << BMFF::Box.get_box(io, self)
        end
      end
    end
  end
end
