data = <<~DATA
1008832
23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,x,x,x,x,x,x,449,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,13,19,x,x,x,x,x,x,x,x,x,29,x,991,x,x,x,x,x,37,x,x,x,x,x,x,x,x,x,x,17
DATA

# p1
depart = data.split[0].to_i
ids = data.split[1].split(',').filter { |x| x != 'x' }.map(&:to_i)
leasts = ids.map { |i| (depart / i.to_f).ceil * i }
p (leasts.min - depart) * ids[leasts.index(leasts.min)]

# p2
offsets = data.split[1].split(',').map.with_index { |x, i| [x.to_i, i] }.filter { |x| x[0] > 0 }

result = 0
offsets.inject(1) { |min, o|
  result += min while (result + o[1]) % o[0] != 0
  min * o[0]
}
puts result
