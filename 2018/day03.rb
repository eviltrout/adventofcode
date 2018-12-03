require 'set'

SIZE = 1000
surface = Array.new(SIZE) { Array.new(SIZE) { Set.new } }

data = File.read("day03.input")

hits = 0
hit_list = Set.new
ids = Set.new
data.each_line do |l|
  if matches = l.match(/\#(\d+) @ (\d+),(\d+): (\d+)x(\d+)/)
    _, id, x, y, w, h = matches.to_a.map(&:to_i)

    ids << id
    (y...y + h).each do |y0|
      (x...x + w).each do |x0|
        contents = surface[y0][x0]
        hits += 1 if contents.size == 1

        contents << id
        if contents.size > 1
          contents.each { |c| hit_list << c }
        end

      end
    end
  end
end

puts "hits: #{hits}"
puts "no-conflicts: #{(ids - hit_list).to_a}"
