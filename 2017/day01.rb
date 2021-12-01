vals = File.read(File.basename(__FILE__, ".rb") + ".input")

vals = vals.chomp.split('').map(&:to_i)

s = vals.size
w = s / 2
sum0 = 0
sum1 = 0
(0..s).each do |i|
  sum0 += vals[i] if vals[i] == vals[(i+1) % s]
  sum1 += vals[i] if vals[i] == vals[(i + w) % s]
end

puts sum0
puts sum1
