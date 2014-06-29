# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleEncryption < BMFF::Box::Full
  attr_accessor :algorithm_id, :iv_size, :kid, :sample_count, :samples
  register_uuid_box "a2394f52-5a9b-4f14-a244-6c427c648df4"

  class Sample
    attr_accessor :initialization_vector, :number_of_entries, :entries
  end

  class Entry
    attr_accessor :bytes_of_clear_data, :bytes_of_encrypted_data
  end

  def parse_data
    super
    if flags & 0x01 > 0
      @algorithm_id = io.get_uint24
      @iv_size = io.get_uint8
      @kid = io.get_uuid
    end
    @sample_count = io.get_uint32
    @samples = []
    @sample_count.times do
      sample = Sample.new
      if @iv_size
        iv_size_to_read = @iv_size
      else
        iv_size_to_read = default_iv_size
      end
      sample.initialization_vector = io.get_byte(iv_size_to_read)
      if flags & 0x02 > 0
        sample.number_of_entries = io.get_uint16
        sample.entries = []
        sample.number_of_entries.times do
          entry = Entry.new
          entry.bytes_of_clear_data = io.get_uint16
          entry.bytes_of_encrypted_data = io.get_uint32
          sample.entries << entry
        end
      end
      @samples << sample
    end
  end

  def default_iv_size
    if track_encryption = find_track_encryption
      track_encryption.default_iv_size
    else
      nil
    end
  end

  @@cached_root_object_id = nil
  @@cached_track_encryption = nil

  def find_track_encryption
    root_container = root
    unless root_container.object_id == @@cached_root_object_id
      @@cached_root_object_id = root_container.object_id
      @@cached_track_encryption = root_container.select_descendants(BMFF::Box::TrackEncryption).first
    end
    @@cached_track_encryption
  end

  private :default_iv_size, :find_track_encryption
end
