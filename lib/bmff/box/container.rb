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
end
