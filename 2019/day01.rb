vals = File.readlines('day01.input').map { |x| x.chomp.to_i }

def calc(v)
  (v / 3).floor - 2
end

# Part 1
puts vals.map { |v| (v / 3).floor - 2 }.sum

def calc2(v)
  fuel = [calc(v), 0].max
  fuel += calc2(fuel) if fuel > 0
  fuel
end

# Part 2
puts vals.map { |v| calc2(v) }.sum

