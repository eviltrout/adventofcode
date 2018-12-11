serial = 1718

grid = Array.new(301) { Array.new(301) }
(1..300).each do |y|
  (1..300).each do |x|
    grid[y][x] = ((((x + 10) * y + serial) * (x + 10)).digits[2] || 0) - 5
  end
end

max = 0
max_at = nil
# sz = 16

cache = {}

def calc(cache, grid, x, y, sz)
  if sz == 1
    return grid[y][x]
  end

  (0...sz).sum { |i| grid[y + i][x..x + sz - 1].sum }
end

(1..5).each do |y|
  (1..5).each do |x|
    printf "%3d", grid[y][x]
  end
  print "\n"
end


(1..300).each do |sz|
  (1..300 - sz).each do |y|
    (1..300 - sz).each do |x|
      value = calc(cache, grid, x, y, sz)
      if value > max
        max_at = [x, y, sz]
        max = value
      end
    end
  end
end
p max_at
p max
