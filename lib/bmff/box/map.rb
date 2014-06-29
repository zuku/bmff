# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Map
  class << self
    @@map = {}
    @@uuid_map = {}

    def register_box(type, klass)
      @@map[type] = klass
    end

    def get_box_class(type)
      @@map[type]
    end

    def register_uuid_box(uuid, klass)
      @@uuid_map[UUIDTools::UUID.parse(uuid).to_s] = klass
    end

    def get_uuid_box_class(uuid)
      @@uuid_map[uuid.to_s]
    end
  end
end
