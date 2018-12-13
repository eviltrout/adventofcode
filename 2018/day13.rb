input = File.read("day13.input")

DIRECTIONS = { "^" => :up, "v" => :down, "<" => :left, ">" => :right }
DIR_LOOKUP = DIRECTIONS.invert
LEFT_BEND = { up: :left, right: :down, left: :up, down: :right }
RIGHT_BEND = { up: :right, right: :up, left: :down, down: :left }
TURN_LEFT = { up: :left, left: :down, down: :right, right: :up }
TURN_RIGHT = { up: :right, right: :down, down: :left, left: :up }

def tick(map, entities)
  entities.sort_by! { |a| [a[:y], a[:x]] }

  crashes = []
  result = { status: :ok, crashes: crashes }

  entities.each do |e|
    next if e[:crashed]

    dest = nil
    case e[:dir]
    when :down
      dest = [e[:x], e[:y] + 1]
    when :up
      dest = [e[:x], e[:y] - 1]
    when :left
      dest = [e[:x] - 1, e[:y]]
    when :right
      dest = [e[:x] + 1, e[:y]]
    end

    dest_val = map[dest[1]][dest[0]]

    # check for collision
    entities.each do |e2|
      if e2[:x] == dest[0] && e2[:y] == dest[1]
        result[:status] = :crashed
        crashes << e
        e[:crashed] = e2[:crashed] = true
      end
    end

    e[:x], e[:y] = dest[0], dest[1]

    e[:dir] = LEFT_BEND[e[:dir]] if dest_val == 'L'
    e[:dir] = RIGHT_BEND[e[:dir]] if dest_val == 'R'

    if dest_val == '+'
      e[:dir] = TURN_LEFT[e[:dir]] if e[:cross] == 0
      e[:dir] = TURN_RIGHT[e[:dir]] if e[:cross] == 2
      e[:cross] += 1
      e[:cross] = 0 if e[:cross] > 2
    end
  end

  entities.delete_if { |e| e[:crashed] }
  result
end

map = []
entities = []

input.each_line.with_index do |l, y|
  row = l.chomp.each_char.map.with_index do |c, x|
    val = c
    case c
    when '\\'
      val = 'L'
    when '/'
      val = 'R'
    when '-', '|'
      val = '#'
    when 'v', '^', '<', '>'
      val = '#'
      entities << { x: x, y: y, dir: DIRECTIONS[c], cross: 0 }
    end
    val
  end
  map << row
end

loop do
  result = tick(map, entities)
  if result[:status] == :crashed
    puts "crash: #{result[:crashes]}"

    if entities.size < 2
      puts "Left over:"
      p entities
      break
    end
  end
end
