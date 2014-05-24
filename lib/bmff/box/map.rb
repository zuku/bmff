# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Map
  class << self
    def register_box(type, klass)
      @@map ||= {}
      @@map[type] = klass
    end

    def get_box_class(type)
      return @@map[type]
    end
  end
end
