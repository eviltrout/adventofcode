require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

class Simulator
  attr_reader :flash_count

  def initialize(input)
    @grid = input.split("\n").map { |r| r.split('').map(&:to_i) }
    @rows, @cols = @grid.size, @grid[0].size
    @flash_count = 0
  end

  def energize(x, y)
    return if x < 0 || y < 0 || x >= @cols || y >= @rows
    return if @to_flash.include?([x, y]) || @flashed.include?([x, y])
    @grid[y][x] += 1
    if @grid[y][x] > 9
      @grid[y][x] = 0
      @to_flash << [x, y]
    end
  end

  def step
    @flashed = []
    @to_flash = []
    (0...@rows).each do |y|
      (0...@cols).each { |x| energize(x, y) }
    end

    until @to_flash.empty?
      pos = @to_flash.shift
      @flashed << pos
      @flash_count += 1
      x, y = pos
      [[-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1]].each do |o|
        energize(x + o[0], y + o[1])
      end
    end
  end

  def bright?
    @grid.all? { |row| row.all? { |c| c == 0 } }
  end

end

sim = Simulator.new(input)

1000.times do |step|
  sim.step
  p sim.flash_count if step == 99 
  if sim.bright?
    puts "Bright: #{step+1}"
    break
  end
end
