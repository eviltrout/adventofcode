require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

class Grid
  attr_accessor :width, :height

  def initialize
    @points = {}
    @width = @height = 0
  end

  def set(x, y)
    @width = x + 1 if x + 1 > @width
    @height = y + 1 if y + 1 > @height
    @points[y] ||= Set.new
    @points[y] << x
  end


  def debug
    (0...@height).each do |y|
      (0...@width).each do |x|
        print (@points[y] || []).include?(x) ? '#' : '.'
      end
      puts
    end
    puts "---"
  end

  def fold(axis, n)
    if axis == 'y'
      (n...@height).each_with_index do |y, i|
        (@points[y] || []).each do |x|
          set(x, n - i)
        end
      end
      (n..@height).each { |y| @points.delete(y) }
      @height = n
    else
      (0...@height).each do |y|
        row = @points[y] || Set.new
        (n...@width).each_with_index do |x, i|
          if row.include?(x)
            set(n - i, y)
            row.delete(x)
          end
        end
      end
      @width = n
    end
  end

  def count
    @points.values.sum { |row| row.size }
  end
end

grid = Grid.new

input.split("\n").each do |l|
  if l =~ /^(\d+),(\d+)$/
    x, y = Regexp.last_match[1..2].map(&:to_i)
    grid.set(x, y)
  end

  if l =~ /fold along (x|y)=(\d+)/
    grid.fold(Regexp.last_match[1], Regexp.last_match[2].to_i)
    puts grid.count
  end
end

grid.debug
