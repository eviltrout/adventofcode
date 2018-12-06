require 'set'

input = File.read("day06.input").chomp

coords = input.each_line.map { |l| l.split(",").map(&:to_i) }

max_x_val = coords.map { |c| c[0] }.max
max_y_val = coords.map { |c| c[1] }.max

# Part One
borders = Set.new
counts = {}
(0..max_y_val + 1).each do |y|
  (0..max_x_val + 1).each do |x|

    closest_val = 1000
    closest = []
    coords.each_with_index do |c, idx|
      dist = (x - c[0]).abs + (y - c[1]).abs
      if dist < closest_val
        closest = [idx]
        closest_val = dist
      elsif dist == closest_val
        closest << idx
      end
    end

    if closest.size == 1
      val = closest[0]
      borders << val if y == 0 || x == 0 || x == max_x_val + 1 || y == max_y_val + 1
      counts[val] = (counts[val] || 0) + 1
    end
  end
end

borders.each { |b| counts.delete(b) }
puts counts.values.max

# Part Two
area = 0
(0..max_y_val + 1).each do |y|
  (0..max_x_val + 1).each do |x|
    total = coords.sum { |c| (x - c[0]).abs + (y - c[1]).abs }
    area += 1 if total < 10000
  end
end
puts area
