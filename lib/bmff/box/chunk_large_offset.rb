# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::ChunkLargeOffset < BMFF::Box::Full
  attr_accessor :entry_count, :chunk_offset
  register_box "co64"

  def parse_data
    super
    @entry_count = io.get_uint32
    @chunk_offset = []
    @entry_count.times do
      @chunk_offset << io.get_uint64
    end
  end
end
