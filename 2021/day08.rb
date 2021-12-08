input = File.read(File.basename(__FILE__, ".rb") + ".input")

lines = input.split("\n")

def solve(inputs)
  by_length = {}
  inputs.each_with_index do |i|
    by_length[i.length] ||= []
    by_length[i.length] << i
  end

  ids = {
    1 => by_length[2][0],
    7 => by_length[3][0],
    4 => by_length[4][0],
    8 => by_length[7][0]
  }

  fe = ids[4] - ids[1]
  counts = Hash.new { 0 }
  by_length[6].each do |i|
    counts[fe[0]] += 1 if i.include?(fe[0])
    counts[fe[1]] += 1 if i.include?(fe[1])
  end
  d = counts.invert[2]
  ids[0] = by_length[6].find { |x| !x.include?(d) }

  (by_length[6] - [ids[0]]).each { |i| ids[(i - ids[4]).size == 2 ? 9 : 6] = i }

  fives = by_length[5]
  rem = fives.map { |x| x - ids[4] }.flatten.tally.invert[1]
  ids[2] = fives.find { |i| i.include?(rem) } 

  (fives - [ids[2]]).each { |i| ids[(i - ids[1]).size == 3 ? 3 : 5] = i }

  Hash[*ids.map { |k, v| [k, v.sort.join] }.flatten].invert
end

sum = 0
sum2 = 0
lines.each do |l|
  tokens = l.split(" ")

  ids = solve(tokens[0..9].map { |x| x.split('') })
  digits = tokens[-4..-1].map { |d| ids[d.split('').sort.join] }

  sum += digits.count { |d| [1, 4, 7, 8].include?(d) }
  sum2 += digits.join.to_i
end
puts [sum, sum2]
