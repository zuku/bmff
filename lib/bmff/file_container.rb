# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::FileContainer
  attr_accessor :boxes

  def initialize(io)
    @boxes = []
    @source_stream = io
  end

  def self.parse(io)
    io.extend(BMFF::BinaryAccessor)
    container = self.new(io)
    until io.eof?
      container.boxes << BMFF::Box.get_box(io, container)
    end
    return container
  end

  # Find boxes which have a specific type from this descendants.
  def select_descendants(boxtype)
    selected_boxes = []
    (@boxes || []).each do |box|
      case boxtype
      when String
        selected_boxes << box if box.type == boxtype
      when Class
        selected_boxes << box if box.kind_of?(boxtype)
      end
      if box.container?
        selected_boxes.concat(box.select_descendants(boxtype))
      end
    end
    selected_boxes
  end
end
