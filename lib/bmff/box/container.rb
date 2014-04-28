# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

module BMFF::Box::Container
  attr_accessor :children

  def container?
    true
  end

  def parse_children
    @children = []
    until eob?
      @children << BMFF::Box.get_box(io, self)
    end
  end

  # Find a box which has a specific type from this children.
  def find(boxtype)
    (@children || []).each do |child|
      case boxtype
      when String
        return child if child.type == boxtype
      when Class
        return child if child.instance_of?(boxtype)
      end
    end
    nil
  end

  # Find boxes which have a specific type from this children.
  def find_all(boxtype)
    found_boxes = []
    (@children || []).each do |child|
      case boxtype
      when String
        found_boxes << child if child.type == boxtype
      when Class
        found_boxes << child if child.instance_of?(boxtype)
      end
    end
    found_boxes
  end

  # Find boxes which have a specific type from this offspring.
  def select_offspring(boxtype)
    selected_boxes = []
    (@children || []).each do |child|
      case boxtype
      when String
        selected_boxes << child if child.type == boxtype
      when Class
        selected_boxes << child if child.instance_of?(boxtype)
      end
      if child.container?
        selected_boxes.concat(child.select_offspring(boxtype))
      end
    end
    selected_boxes
  end
end
