input = File.read(File.basename(__FILE__, ".rb") + ".input")

input = input.split(",").map(&:to_i).sort
mid = input[input.size / 2]
puts input.map { |i| (i - mid).abs }.sum

min = (input.max * input.max + 1) / 2
puts (0..input.max).map { |i|
  fuel = input.map do |x| 
    delta = (x - i).abs 
    (delta * (delta + 1)) / 2
  end.sum
}.min
