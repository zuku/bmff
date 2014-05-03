# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::SampleDependencyType < BMFF::Box::Full
  attr_accessor :is_leading, :sample_depends_on, :sample_is_depended_on, :sample_has_redundancy
  register_box "sdtp"

  def parse_data
    super
    sample_size_box = parent.find(BMFF::Box::SampleSize)
    if sample_size_box
      sample_count = sample_size_box.sample_count
      @is_leading = []
      @sample_depends_on = []
      @sample_is_depended_on = []
      @sample_has_redundancy = []
      sample_count.times do
        tmp = io.get_uint8
        @is_leading << (tmp >> 6)
        @sample_depends_on << (tmp >> 4) & 0x03
        @sample_is_depended_on << (tmp >> 2) & 0x03
        @sample_has_redundancy << (tmp & 0x03)
      end
    end
  end
end
