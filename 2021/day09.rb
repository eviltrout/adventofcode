require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

rows = input.split("\n")
grid = rows.map { |r| r.split('').map(&:to_i) }

def safe_get(grid, x, y)
  return nil if x < 0 || y < 0 || x >= grid[0].size || y >= grid.size
  grid[y][x]
end

def trace_basin(grid, x, y, basin = Set.new)
  return basin if basin.include?([x, y])
  val = safe_get(grid, x, y)
  return basin if val.nil? || val == 9

  basin << [x, y]
  basin = trace_basin(grid, x - 1, y, basin)
  basin = trace_basin(grid, x + 1, y, basin)
  basin = trace_basin(grid, x, y - 1, basin)
  basin = trace_basin(grid, x, y + 1, basin)
  basin
end

smallest = []
grid.size.times do |y|
  grid[0].size.times do |x|
    min_close = [safe_get(grid, x, y - 1), safe_get(grid, x - 1, y), safe_get(grid, x, y + 1), safe_get(grid, x + 1, y)].compact.min
    smallest << [x, y] if grid[y][x] < min_close
  end
end

puts smallest.map { |i| grid[i[1]][i[0]] + 1 }.sum
puts smallest.map { |s| trace_basin(grid, *s).size }.sort[-3..-1].inject(:*)
