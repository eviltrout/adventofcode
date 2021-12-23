require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

algo, grid = input.split("\n\n")
algo = algo.gsub("\n", "").chars.map { |c| c == '#' ? 1 : 0 }

class Runner
  def initialize(algo)
    @points = Set.new
    @algo = algo
    @iterations = 0
  end

  def set_point(target, x, y)
    target << [x, y]
  end

  def set(x, y)
    set_point(@points, x, y)
  end

  def get(x, y)
    if @xrange.include?(x) && @yrange.include?(y)
      @points.include?([x, y]) ? 1 : 0
    else
      @iterations % 2
    end
  end

  def number_at(x, y)
    n = []
    n << get(x-1, y-1) << get(x, y-1) << get(x+1, y-1)
    n << get(x-1, y) << get(x, y) << get(x+1, y)
    n << get(x-1, y+1) << get(x, y+1) << get(x+1, y+1)
    n.join.to_i(2)
  end

  def calculate_ranges
    minx = miny = 10000000000
    maxx = maxy = -1000000000

    @points.each do |p|
      x, y = p
      minx = x if x < minx
      miny = y if y < miny
      maxx = x if x > maxx
      maxy = y if y > maxy
    end

    @yrange = miny..maxy
    @xrange = minx..maxx
  end

  def step
    new_points = Set.new

    (@yrange.first-1..@yrange.last+1).each do |y|
      (@xrange.first-1..@yrange.last+1).each do |x|
        n = number_at(x, y)
        if @algo[n] == 1
          set_point(new_points, x, y)
        end
      end
    end
    @iterations += 1
    @points = new_points
    calculate_ranges
  end

  def debug
    @yrange.each do |y|
      @xrange.each do |x|
        print get(x, y) == 1 ? '#' : '.'
      end
      puts
    end
    puts "---"
  end

  def count
    @points.size
  end
end

r = Runner.new(algo)
grid.split("\n").each_with_index do |l, y|
  l.chars.each_with_index do |c, x|
    r.set(x, y) if c == '#'
  end
end

r.calculate_ranges
50.times do |c|
  r.step
end
r.debug
puts r.count
