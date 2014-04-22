# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

module BMFF::Box; end

require "bmff/box/base"
require "bmff/box/unknown"
require "bmff/box/file_type"

module BMFF::Box
  def self.get_box(io, parent)
    offset = io.pos
    size = io.sysread(4).unpack("N").first
    type = io.sysread(4).unpack("a4").first

    klass = get_box_class(type)
    box = klass.new
    box.io = io
    box.offset = offset
    box.parent = parent
    box.size = size
    box.type = type

    box.parse
    return box
  end

  def self.get_box_class(type)
    return case type
    when "ftyp"
      BMFF::Box::FileType
    else
      BMFF::Box::Unknown
    end
  end
end
