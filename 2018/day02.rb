data = File.readlines("day02.input").map { |x| x.chomp }

# Part One
twos = 0
threes = 0

data.each do |l|
  uniq = l.chars.uniq
  twos += 1 if uniq.any? { |x| l.count(x) == 2 }
  threes += 1 if uniq.any? { |x| l.count(x) == 3 }
end

puts "checksum: #{twos * threes}"

# Part Two
data.combination(2).each do |x, y|
  diff = 0
  x.each_char.with_index(0) do |c, idx|
    diff += 1 if c != y[idx]
    break if (diff > 1)
  end

  if diff == 1
    result = ""
    x.each_char.with_index(0) { |c, idx| result << c if c == y[idx] }
    puts result
    break
  end
end
