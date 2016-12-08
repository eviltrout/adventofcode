WIDTH = 50
HEIGHT = 6

def show_grid(grid)
  grid.each do |row|
    row.each {|col| print col }
    puts
  end
end

def fill(grid, w, h, val)
  h.times do |y|
    grid[y] = grid[y] || []
    w.times {|x| grid[y][x] = val }
  end
end

def rotate_col(grid, x)
  last = grid[HEIGHT-1][x]
  (HEIGHT-1).downto(1) {|y| grid[y][x] = grid[y-1][x] }
  grid[0][x] = last
end

def rotate_row(grid, y)
  last = grid[y][WIDTH-1]
  (WIDTH-1).downto(1) {|x| grid[y][x] = grid[y][x-1] }
  grid[y][0] = last
end

grid = []
fill(grid, WIDTH, HEIGHT, 0)

input = File.read("day08.input")

input.split("\n").each do |i|
  parsed = i.split
  case parsed[0]
  when 'rect'
    dims = parsed[1].split('x').map(&:to_i)
    fill(grid, dims[0], dims[1], 1)
  when 'rotate'
    parsed[-1].to_i.times do
      rotate_col(grid, parsed[2][2..-1].to_i) if parsed[1] == 'column'
      rotate_row(grid, parsed[2][2..-1].to_i) if parsed[1] == 'row'
    end
  end
end

show_grid(grid)
p grid.map {|r| r.inject(:+) }.inject(:+)

