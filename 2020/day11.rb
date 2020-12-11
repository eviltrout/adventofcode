data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
L.LL.LL.LL
LLLLLLL.LL
L.L.L..L..
LLLL.LL.LL
L.LL.LL.LL
L.LLLLL.LL
..L.L.....
LLLLLLLLLL
L.LLLLLL.L
L.LLLLL.LL
DATA


class Grid
	NEIGHBORS = [ [-1, -1], [0, -1], [1, -1], [-1, 0], [1, 0], [-1, 1], [0, 1], [1, 1] ]

	def initialize(input)
		@rows = input.split("\n").map { |r| r.split('') }
		@size_y = @rows.size
		@size_x = @rows[0].size
	end

	def debug
		@rows.each do |row|
			puts row.join
		end
		puts "---"
	end

	def calc(x, y)
		val = @rows[y][x]
		return ['.', false] if val == '.'

		if val == 'L' && NEIGHBORS.none? { |n|
			x0, y0 = x + n[0], y + n[1]
			(x0 >= 0 && y0 >= 0 && x0 < @size_x && y0 < @size_y && @rows[y0][x0] == '#')
		}
			return ['#', true]
		end

		if val == '#'
			n_count = 0
			NEIGHBORS.each { |n|
				x0, y0 = x + n[0], y + n[1]
				n_count +=1 if (x0 >= 0 && y0 >= 0 && x0 < @size_x && y0 < @size_y && @rows[y0][x0] == '#')
				break if n_count == 4
			}
			return ['L', true] if n_count == 4
		end
		return [val, false]
	end

	def tick
		result = []
		changed = false
		seat_count = 0
		(0...@size_y).each do |y|
			row = []
			(0...@size_x).each do |x|
				val, val_changed = calc(x, y)
				changed |= val_changed
				seat_count += 1 if val == '#'
				row << val
			end
			result << row
		end
		@rows = result
		[changed, seat_count]
	end

	def find_statis
		changed, seat_count = tick
		return !changed ? seat_count : find_statis
	end
end

class ComplexGrid < Grid
	def raycast(x, y, dx, dy)
		loop do
			x += dx
			y += dy
			return false if (x < 0 || y < 0 || x >= @size_x || y >= @size_y)
			val = @rows[y][x]
			return true if val == '#'
			return false if val == 'L'
		end
	end

	def calc(x, y)
		val = @rows[y][x]
		return ['.', false] if val == '.'

		if val == 'L' && NEIGHBORS.none? { |n| raycast(x, y, n[0], n[1]) }
			return ['#', true]
		end

		if val == '#'
			n_count = 0
			NEIGHBORS.each { |n|
				n_count +=1 if raycast(x, y, n[0], n[1])
				break if n_count == 5
			}
			return ['L', true] if n_count == 5
		end
		return [val, false]
	end
end

g = Grid.new(data)
p g.find_statis
g = ComplexGrid.new(data)
p g.find_statis
