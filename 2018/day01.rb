require 'set'

vals = File.readlines('day01.input').map { |x| x.chomp.to_i }

# Part One
puts vals.sum

# Part Two
prev_sums = Set.new { 0 }

sum = 0
loop do
  vals.each do |v|
    sum += v
    if prev_sums.include?(sum)
      puts sum
      exit
    end
    prev_sums << sum
  end
end
