input = File.read('day03.input')

# input = "R98,U47,R26,D63,R33,U87,L62,D20,R33,U53,R51\nU98,R91,D20,R16,D67,R40,U7,R15,U6,R7"
wires = input.split("\n")

grids = [ {}, {} ]
distances = []
steps = []

wires.each_with_index do |wire, i|
  x, y = 0, 0
  travelled = 0
  move = ->(x1, y1) {
    x, y = x1, y1
    travelled += 1
    grids[i][y] ||= {}
    grids[i][y][x] = travelled if grids[i][y][x].nil?

    grids[0][y] ||= {} if i == 1

    if i == 1 && !grids[0][y][x].nil?
      distances << x.abs + y.abs
      steps << (travelled + (grids[0][y][x] || 0))
    end
  }

  wire.split(',').each do |inst|
    dir, length = inst[0], inst[1..-1].to_i

    case dir
    when 'U'
      length.times { move.call(x, y - 1) }
    when 'D'
      length.times { move.call(x, y + 1) }
    when 'L'
      length.times { move.call(x - 1, y) }
    when 'R'
      length.times { move.call(x + 1, y) }
    end
  end
end

puts distances.min
puts steps.min

