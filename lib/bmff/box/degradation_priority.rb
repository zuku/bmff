# coding: utf-8
# vim: set expandtab tabstop=2 shiftwidth=2 softtabstop=2 autoindent:

class BMFF::Box::DegradationPriority < BMFF::Box::Full
  attr_accessor :priority
  register_box "stdp"

  def parse_data
    super
    sample_size_box = parent.find(BMFF::Box::SampleSize)
    if sample_size_box
      sample_count = sample_size_box.sample_count
      @priority = []
      sample_count.times do
        @priority << io.get_uint16
      end
    end
  end
end
