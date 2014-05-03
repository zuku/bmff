# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::Base
  attr_accessor :size, :type, :largesize, :usertype,
                :io, :offset, :parent

  def self.register_box(*boxtypes)
    boxtypes.each do |boxtype|
      BMFF::Box::Map.register_box(boxtype, self)
    end
  end

  def actual_size
    return largesize if size == 1
    return nil if size == 0
    return size
  end

  def remaining_size
    if actual_size
      return (offset + actual_size) - io.pos
    end
    nil
  end

  # end of box?
  def eob?
    if actual_size
      return io.pos >= offset + actual_size
    else
      return io.eof?
    end
  end

  def seek_to_end
    if actual_size
      io.pos = offset + actual_size
    else
      io.seek(0, IO::SEEK_END)
    end
  end

  def parse
    parse_data
    if actual_size
      if io.pos > offset + actual_size
        raise RangeError, "Given box size is smaller than expected."
      end
    end
    seek_to_end
  end

  def parse_data
    if size == 1
      @largesize = io.get_uint64
    end
    if type == 'uuid'
      @usertype = io.get_uuid
    end
  end

  def container?
    false
  end
end
