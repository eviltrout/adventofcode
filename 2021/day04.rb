require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

lines = input.gsub("\n\n", "\n").split("\n")
instructions = lines[0].split(",").map(&:to_i)

grids = lines[1..-1].each_slice(5).map { |l| l.map { |m| m.split.map(&:to_i) } }

instructions.each do |ins|
  grids.each do |grid|
    (0..4).each do |y|
      (0..4).each do |x|
        grid[y][x] = nil if grid[y][x] == ins
      end
    end
  end

  results = Set.new
  grids.each do |g|
    (0..4).each do |i|
      results << g if g[i].uniq == [nil] || (0..4).all? { |j| g[j][i].nil? }
    end
  end
  results.each do |g|
    puts g.sum { |r| r.compact.sum } * ins
    grids.delete(g)
  end
end

