data = File.read(File.basename(__FILE__, ".rb") + ".input")

# data = <<~DATA
# 1-3 a: abcde
# 1-3 b: cdefg
# 2-9 c: ccccccccc
# DATA

puts data.split("\n").count { |l|
  min, max, l, pw = l.chomp.split(/[\- :]+/)
  (min.to_i..max.to_i).include?(pw.count(l))
}

puts data.split("\n").count { |l|
  min, max, l, pw = l.chomp.split(/[\- :]+/)
  (pw[min.to_i-1] == l) ^ (pw[max.to_i-1] == l)
}
