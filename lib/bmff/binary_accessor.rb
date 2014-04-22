# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

module BMFF::BinaryAccessor
  def get_uint8
    sysread(1).unpack("C").first
  end
end
