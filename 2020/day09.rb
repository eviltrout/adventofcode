data = File.read(File.basename(__FILE__, ".rb") + ".input")

test_data = <<~DATA
35
20
15
25
47
40
62
55
65
95
102
117
150
182
127
219
299
277
309
576
DATA

data = data.split.map(&:to_i)

pre = 25
num = data[(pre...data.size).find { |i| !data[i-pre..i-1].combination(2).any? { |x, y| x + y == data[i] } }]
puts num

(0..data.size-1).each do |x|
  (x..data.size-1).each do |y|
    range = data[x..y]
    if range.sum == num
      puts range.min + range.max
      exit
    end
  end
end
