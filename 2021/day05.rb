require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

lines = input.gsub(" -> ", ",").split("\n").map { |l| l.split(",").map(&:to_i) }

def norm(v)
  return 0 if v.zero?
  v.positive? ? 1 : -1
end

grid, grid2 = Hash.new { 0 }, Hash.new { 0 }
lines.each do |l|
  x0, y0, x1, y1 = l
  sx, sy = norm(x1 - x0), norm(y1 - y0)

  nondiag = x0 == x1 || y0 == y1
  while (x0 != x1 || y0 != y1) 
    grid["#{x0}:#{y0}"] += 1 if nondiag
    grid2["#{x0}:#{y0}"] += 1
    x0 += sx
    y0 += sy
  end
  grid["#{x0}:#{y0}"] += 1 if nondiag
  grid2["#{x0}:#{y0}"] += 1
end

puts grid.count { |k, v| v > 1 }
puts grid2.count { |k, v| v > 1 }
