data = File.read(File.basename(__FILE__, ".rb") + ".input")

# data = <<~DATA
# ..##.......
# #...#...#..
# .#....#..#.
# ..#.#...#.#
# .#...##..#.
# ..#.##.....
# .#.#.#....#
# .#........#
# #.##...#...
# #...##....#
# .#..#...#.#
# DATA

rows = data.split

series = [1, 3, 5, 7].map { |s| count = rows.each.with_index.count { |row, i| row[(i * s) % row.size] == '#' } }
series << rows.each.with_index.count { |row, i| i.even? && (row[(i / 2) % row.size] == '#') }
puts series.inspect
puts series.inject(:*)

