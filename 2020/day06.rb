data = File.read(File.basename(__FILE__, ".rb") + ".input")

test_data = <<~DATA
abc

a
b
c

ab
ac

a
a
a
a

b
DATA

puts data.split("\n\n").sum { |g| g.gsub("\n", "").split('').uniq.size }
puts data.split("\n\n").sum { |g| g.gsub("\n", "").split('').uniq.count { |c| g.split("\n").all? { |v| v.include?(c) } } }
