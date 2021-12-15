require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

grid = input.split("\n").map { |r| r.chars.map(&:to_i) }
oh = grid.size
ow = grid[0].size

(0...oh).each do |y|
  (0...ow).each do |x|
    dest = ow
    4.times do |i|
      grid[y][x+dest] = grid[y][x+dest-ow] + 1
      grid[y][x+dest] = 1 if grid[y][x+dest] > 9
      dest += ow
    end
  end
end
ow = grid[0].size
(0...oh).each do |y|
  (0...ow).each do |x|
    dest = oh
    4.times do |i|
      grid[y+dest] ||= []
      grid[y+dest][x] = grid[y+dest-oh][x] + 1
      grid[y+dest][x] = 1 if grid[y+dest][x] > 9
      dest += oh
    end
  end
end

class Point
  attr_reader :x, :y, :parent, :cost

  def initialize(x, y, parent, cost)
    @x, @y, @parent, @cost = x, y, parent, cost
  end
end

def key(x, y)
  "#{x}:#{y}"
end

class PathFinder
  attr_reader :grid

  def initialize(grid)
    @grid = grid
    @height = @grid.size
    @width = @grid[0].size
    @open = {}
    @closed = {}

    add(0, 0, nil)
  end

  def find_cheapest
    @open.values.sort_by { |p| p.cost }[0]
  end

  def add(x, y, parent)
    k = key(x, y)
    return if x < 0 || y < 0 || x >= @width || y >= @height
    return if @closed.include?(k)

    cost = (parent&.cost || 0) + @grid[y][x]
    existing = @open[k]
    return if existing && existing.cost < cost
    @open[k] = Point.new(x, y, parent, cost)
  end

  def step
    p = find_cheapest
    add(p.x-1, p.y, p)
    add(p.x+1, p.y, p)
    add(p.x, p.y-1, p)
    add(p.x, p.y+1, p)

    k = key(p.x, p.y)
    @open.delete(k)
    @closed[k] = p
  end

  def fill
    step until @open.empty?
  end

  def shortest_path
    p = @closed[key(@width-1, @height-1)]
    sum = 0
    while p.parent
      sum += grid[p.y][p.x]
      p = p.parent
    end
    sum
  end
end

pf = PathFinder.new(grid)
pf.fill
puts pf.shortest_path
