discs = [
  {size: 17, current: 5, pos: 1},
  {size: 19, current: 8, pos: 2},
  {size: 7, current: 1, pos: 3},
  {size: 13, current: 7, pos: 4},
  {size: 5, current: 1, pos: 5},
  {size: 3, current: 0, pos: 6},
  {size: 11, current: 0, pos: 7},
]

t = 0
while true
  t += 1

  found = 0
  discs.each_with_index do |d, i|
    break unless ((d[:current] + t + d[:pos]) % d[:size]) == 0
    found += 1
  end

  if found == discs.size
    puts "---> #{t}"
    exit
  end
end
