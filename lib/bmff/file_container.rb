# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::FileContainer
  include(BMFF::Box::Container)
  alias :boxes :children

  def initialize(io)
    @source_stream = io
  end

  def self.parse(io)
    io.extend(BMFF::BinaryAccessor)
    container = self.new(io)
    until io.eof?
      container.add_child BMFF::Box.get_box(io, container)
    end
    return container
  end
end
