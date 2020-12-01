vals = File.readlines(File.basename(__FILE__, ".rb") + ".input").map { |x| x.chomp.to_i }

# vals = [1721,979, 366, 299, 675, 1456]

puts vals.combination(2).find { |x| x.sum === 2020 }.inject(:*)
puts vals.combination(3).find { |x| x.sum === 2020 }.inject(:*)
