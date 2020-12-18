require 'set'

data = <<~DATA
..#..#.#
##.#..#.
#....#..
.#..####
.....#..
...##...
.#.##..#
.#.#.#.#
DATA

NEIGHBORS = []
(-1..1).each do |w|
  (-1..1).each do |z|
    (-1..1).each do |y|
      (-1..1).each do |x|
        NEIGHBORS << [x, y, z, w] unless x == 0 && y == 0 && z == 0 && w == 0
      end
    end
  end
end

def iterate(cubes, d)
  ranges = d.times.map { [0, 0] }
  d.times.each do |d|
    cubes.each { |c| ranges[d] = [ [ranges[d][0], c[d] - 1].min, [ranges[d][1], c[d] + 1].max ] }
  end

  result = Set.new
  (d == 3 ? [0] : ranges[3][0]..ranges[3][1]).each do |w|
    (ranges[2][0]..ranges[2][1]).each do |z|
      (ranges[1][0]..ranges[1][1]).each do |y|
        (ranges[0][0]..ranges[0][1]).each do |x|
          pos = [x, y, z, w]
          active = cubes.include?(pos)
          c = NEIGHBORS.count { |n| cubes.include?([x + n[0], y + n[1], z + n[2], w + n[3]]) }
          result << pos if (active && (c == 2 || c == 3)) || (!active && c == 3)
        end
      end
    end
  end
  result
end

cubes = Set.new
data.split("\n").each.with_index { |row, y|
  row.split('').each.with_index { |col, x| cubes << [x, y, 0, 0] if col == '#' }
}
cubes3 = cubes.dup
6.times { cubes3 = iterate(cubes3, 3) }
puts cubes3.size

6.times { cubes = iterate(cubes, 4) }
puts cubes.size
