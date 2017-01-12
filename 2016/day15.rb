# discs = [{size: 5, current: 4}, {size: 2, current: 1}]

discs = [
  {size: 17, current: 5},
  {size: 19, current: 8},
  {size: 7, current: 1},
  {size: 13, current: 7},
  {size: 5, current: 1},
  {size: 3, current: 0},
]

t = 0

while true
  all = true
  discs.each_with_index do |d, i|
    all = all && ((d[:current] + t) % d[:size]) == i
    break unless all
  end
  if all
    puts "Found #{t-1}"
    break
  end
  t += (3 * 5 * 13 * 7 * 19 * 17)
  
  puts t if (t % 1000) == 0
end


