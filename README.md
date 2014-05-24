# bmff

This gem library is an ISO Base Media File Format (BMFF) parser.
You can parse BMFF file.
And you may be able to parse a file related to BMFF like MP4.

## Installation

Add this line to your application's Gemfile:

    gem 'bmff'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install bmff

## Usage

### Dump Box Structure

```ruby
require "bmff"

def print_box(box, level = 0)
  puts "#{' ' * level}#{box.type} #{box.class}"
  if box.container?
    box.children.each do |child|
      print_box(child, level + 1)
    end
  end
end

open("/path/to/video.mp4", "rb:ascii-8bit") do |f|
  file_container = BMFF::FileContainer.parse(f)
  file_container.boxes.each do |box|
    print_box(box)
  end
end
```

### Get Video Duration from Media Header Box

```ruby
require "bmff"

open("/path/to/video.mp4", "rb:ascii-8bit") do |f|
  file_container = BMFF::FileContainer.parse(f)
  media_header = file_container.select_descendants(BMFF::Box::MediaHeader).first
  if media_header
    puts media_header.duration / media_header.timescale.to_f
  end
end
```

### Get Each Fragment Duration

```ruby
require "bmff"

open("/path/to/video.ismv", "rb:ascii-8bit") do |f|
  file_container = BMFF::FileContainer.parse(f)
  file_container.select_descendants(BMFF::Box::TrackRun).each do |track_run|
    puts track_run.sample_duration.inject {|result, item| result + item}
  end
end
```

## Progress

### ISO/IEC 14496-12:2012

|Box Name                                     |      Type      |   Status  |
|:--------------------------------------------|:--------------:|:---------:|
|File Type Box                                |      ftyp      |OK         | \ 4.3
|Media Data Box                               |      mdat      |OK         | \ 8.1.1
|Free Space Box                               |   free, skip   |OK         | \ 8.1.2
|Progressive Download Information Box         |      pdin      |OK         | \ 8.1.3
|Movie Box                                    |      moov      |OK         | \ 8.2.1
|Movie Header Box                             |      mvhd      |OK         | \ 8.2.2
|Track Box                                    |      trak      |OK         | \ 8.3.1
|Track Header Box                             |      tkhd      |OK         | \ 8.3.2
|Track Reference Box                          |      tref      |OK         | \ 8.3.3
|Track Group Box                              |      trgr      |OK         | \ 8.3.4
|Media Box                                    |      mdia      |OK         | \ 8.4.1
|Media Header Box                             |      mdhd      |OK         | \ 8.4.2
|Handler Reference Box                        |      hdlr      |OK         | \ 8.4.3
|Media Information Box                        |      minf      |OK         | \ 8.4.4
|Video Media Header Box                       |      vmhd      |OK         | \ 8.4.5.2
|Sound Media Header Box                       |      smhd      |OK         | \ 8.4.5.3
|Hint Media Header Box                        |      hmhd      |OK         | \ 8.4.5.4
|Null Media Header Box                        |      nmhd      |OK         | \ 8.4.5.5
|Sample Table Box                             |      stbl      |OK         | \ 8.5.1
|Sample Description Box                       |      stsd      |OK         | \ 8.5.2
|Degradation Priority Box                     |      stdp      |OK         | \ 8.5.3
|Decoding Time to Sample Box                  |      stts      |OK         | \ 8.6.1.2
|Composition Time to Sample Box               |      ctts      |OK         | \ 8.6.1.3
|Composition to Decode Box                    |      cslg      |OK         | \ 8.6.1.4
|Sync Sample Box                              |      stss      |OK         | \ 8.6.2
|Shadow Sync Sample Box                       |      stsh      |OK         | \ 8.6.3
|Independent and Disposable Samples Box       |      sdtp      |OK         | \ 8.6.4
|Edit Box                                     |      edts      |OK         | \ 8.6.5
|Edit List Box                                |      elst      |OK         | \ 8.6.6
|Data Information Box                         |      dinf      |OK         | \ 8.7.1
|Data Reference Box                           |url , urn , dref|OK         | \ 8.7.2
|Sample Size Box                              |      stsz      |OK         | \ 8.7.3.2
|Compact Sample Size Box                      |      stz2      |OK         | \ 8.7.3.3
|Sample to Chunk Box                          |      stsc      |OK         | \ 8.7.4
|Chunk Offset Box                             |   stco, co64   |OK         | \ 8.7.5
|Padding Bits Box                             |      padb      |OK         | \ 8.7.6
|Sub-Sample Information Box                   |      subs      |OK         | \ 8.7.7
|Sample Auxiliary Information Sizes Box       |      saiz      |Parsable   | \ 8.7.8
|Sample Auxiliary Information Offsets Box     |      saio      |Parsable   | \ 8.7.9
|Movie Extends Box                            |      mvex      |Parsable   | \ 8.8.1
|Movie Extends Header Box                     |      mehd      |Parsable   | \ 8.8.2
|Track Extends Box                            |      trex      |Parsable   | \ 8.8.3
|Movie Fragment Box                           |      moof      |Parsable   | \ 8.8.4
|Movie Fragment Header Box                    |      mfhd      |Parsable   | \ 8.8.5
|Track Fragment Box                           |      traf      |Parsable   | \ 8.8.6
|Track Fragment Header Box                    |      tfhd      |Parsable   | \ 8.8.7
|Track Fragment Run Box                       |      trun      |Parsable   | \ 8.8.8
|Movie Fragment Random Access Box             |      mfra      |Parsable   | \ 8.8.9
|Track Fragment Random Access Box             |      tfra      |Parsable   | \ 8.8.10
|Movie Fragment Random Access Offset Box      |      mfro      |Parsable   | \ 8.8.11
|Track fragment decode time                   |      tfdt      |Parsable   | \ 8.8.12
|Level Assignment Box                         |      leva      |Parsable   | \ 8.8.13
|Sample to Group Box                          |      sbgp      |Not yet    | \ 8.9.2
|Sample Group Description Box                 |      sgpd      |Not yet    | \ 8.9.3
|User Data Box                                |      udta      |Parsable   | \ 8.10.1
|Copyright Box                                |      cprt      |Parsable   | \ 8.10.2
|Track Selection Box                          |      tsel      |Parsable   | \ 8.10.3
|The Meta Box                                 |      meta      |Not yet    | \ 8.11.1
|XML Box                                      |      xml       |Not yet    | \ 8.11.2
|Binary XML Box                               |      bxml      |Not yet    | \ 8.11.2
|The Item Location Box                        |      iloc      |Not yet    | \ 8.11.3
|Primary Item Box                             |      pitm      |Not yet    | \ 8.11.4
|Item Protection Box                          |      ipro      |Not yet    | \ 8.11.5
|Item Information Box                         |      iinf      |Not yet    | \ 8.11.6
|Additional Metadata Container Box            |      meco      |Not yet    | \ 8.11.7
|Metabox Relation Box                         |      mere      |Not yet    | \ 8.11.8
|Item Data Box                                |      idat      |Not yet    | \ 8.11.11
|Item Reference Box                           |      iref      |Not yet    | \ 8.11.12
|Protection Scheme Information Box            |      sinf      |Not yet    | \ 8.12.1
|Original Format Box                          |      frma      |Not yet    | \ 8.12.2
|Scheme Type Box                              |      schm      |Not yet    | \ 8.12.5
|Scheme Information Box                       |      schi      |Not yet    | \ 8.12.6
|FD Item Information Box                      |      fiin      |Not yet    | \ 8.13.2
|File Partition Box                           |      fpar      |Not yet    | \ 8.13.3
|FEC Reservoir Box                            |      fecr      |Not yet    | \ 8.13.4
|FD Session Group Box                         |      segr      |Not yet    | \ 8.13.5
|Group ID to Name Box                         |      gitn      |Not yet    | \ 8.13.6
|File Reservoir Box                           |      fire      |Not yet    | \ 8.13.7
|Sub Track Box                                |      strk      |Not yet    | \ 8.14.3
|Sub Track Information Box                    |      stri      |Not yet    | \ 8.14.4
|Sub Track Definition Box                     |      strd      |Not yet    | \ 8.14.5
|Sub Track Sample Group Box                   |      stsg      |Not yet    | \ 8.14.6
|Restricted Scheme Information Box            |      rinf      |Not yet    | \ 8.15.3
|Stereo Video Box                             |      stvi      |Not yet    | \ 8.15.4.2
|Segment Type Box                             |      styp      |Not yet    | \ 8.16.2
|Segment Index Box                            |      sidx      |Not yet    | \ 8.16.3
|Subsegment Index Box                         |      ssix      |Not yet    | \ 8.16.4
|Producer Reference Time Box                  |      prft      |Not yet    | \ 8.16.5


## Contributing

1. Fork it ( http://github.com/zuku/bmff/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Copyright (c) 2014 Takayuki Ogiso.

This library (except audio-visual contents) is released under the MIT license.
See LICENSE.txt.

The audio-visual contents are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License. To view a copy of this license, visit http://creativecommons.org/licenses/by-nc-sa/4.0/.
