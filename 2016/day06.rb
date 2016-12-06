input = "eedadn\ndrvtee\neandsr\nraavrd\natevrs\ntsrnev\nsdttsa\nrasrtv\nnssdts\nntnada\nsvetve\ntesnvt\nvntsnd\nvrdear\ndvrsen\nenarar"

input = File.read("day06.input")

# use min_by for part 2
puts input.split
          .map {|r| r.split('') }
          .transpose
          .map {|c| c.group_by {|x| x }.max_by {|x| x[1].size}[0] }
          .join
