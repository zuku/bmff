# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleDescription < BMFF::Box::Full
  attr_accessor :entry_count
  register_box "stsd"
  include(BMFF::Box::Container)

  def parse_data
    super
    @entry_count = io.get_uint32
    if handler = parent.parent.parent.find(BMFF::Box::Handler)
      @entry_count.times do
        case handler.handler_type
        when "soun"
          add_child BMFF::Box.get_box(io, self, BMFF::Box::AudioSampleEntry)
        when "vide"
          add_child BMFF::Box.get_box(io, self, BMFF::Box::VisualSampleEntry)
        when "hint"
          add_child BMFF::Box.get_box(io, self, BMFF::Box::HintSampleEntry)
        when "meta"
          add_child BMFF::Box.get_box(io, self)
        end
      end
    end
  end
end
