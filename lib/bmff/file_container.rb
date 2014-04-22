# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::FileContainer
  attr_accessor :boxes

  def initialize(io)
    @boxes = []
    @source_stream = io
  end

  def self.parse(io)
    container = self.new(io)
    until io.eof?
      container.boxes << BMFF::Box.get_box(io, container)
    end
    return container
  end
end
