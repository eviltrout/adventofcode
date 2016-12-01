loc = [0, 0]

visited = {}
direction = :north

TURNS = {
  'L' => { north: :west, east: :north, south: :east, west: :south },
  'R' => { north: :east, east: :south, south: :west, west: :north }
}

def distance(pos)
  pos.map(&:abs).reduce(:+)
end

input = File.read('day01.input')

revisited = false

input.strip.split(", ").each do |i|

  direction = TURNS[i[0]][direction]

  (0..i[1..-1].to_i-1).each do |s|
    case direction
    when :north then loc[1] -= 1
    when :south then loc[1] += 1
    when :east  then loc[0] -= 1
    when :west  then loc[0] += 1
    end

    if !revisited
      key = loc.dup
      if visited[key]
        puts "Visited #{key} already -> #{distance(key)}"
        revisited = true
      end
      visited[key] = true
    end
  end

end

puts distance(loc)
