FAR = 999
SOLID = -1
READING = [[0, -1], [-1, 0], [1, 0], [0, 1]]

inputs = []

# 0
inputs << <<~DATA
#######
#E..G.#
#...#.#
#.G.#G#
#######
DATA

# 1
inputs << <<~DATA
#######
#.E...#
#.....#
#...G.#
#######
DATA

# 2
inputs << <<~DATA
#############
#E..........#
###########.#
#G..........#
#############
DATA

# 3
inputs << <<~DATA
#########
#G..G..G#
#.......#
#.......#
#G..E..G#
#.......#
#.......#
#G..G..G#
#########
DATA

# 4
inputs << <<~DATA
#######
#.G...#
#...EG#
#.#.#G#
#..G#E#
#.....#
#######
DATA

# 47 * 590 = 27730

# 5
inputs << <<~DATA
#######
#G..#E#
#E#E.E#
#G.##.#
#...#E#
#...E.#
#######
DATA

# 6
inputs << <<~DATA
#######
#E..EG#
#.#G.E#
#E.##E#
#G..#.#
#..E#.#
#######
DATA

# Combat ends after 46 full rounds
# Elves win with 859 total hit points left
# Outcome: 46 * 859 = 39514

# 7
inputs << <<~DATA
#######
#E.G#.#
#.#G..#
#G.#.G#
#G..#.#
#...E.#
#######
DATA

# Combat ends after 35 full rounds
# Goblins win with 793 total hit points left
# Outcome: 35 * 793 = 27755

# 8
inputs << <<~DATA
#######
#.E...#
#.#..G#
#.###.#
#E#G#G#
#...#G#
#######
DATA

# Combat ends after 54 full rounds
# Goblins win with 536 total hit points left
# Outcome: 54 * 536 = 28944

# 9
inputs << <<~DATA
#########
#G......#
#.E.#...#
#..##..G#
#...##..#
#...#...#
#.G...G.#
#.....G.#
#########
DATA

# Combat ends after 20 full rounds
# Goblins win with 937 total hit points left
# Outcome: 20 * 937 = 18740

def hash(x, y)
  (y * 10000) + x
end

class Entity
  attr_reader :type
  attr_accessor :x, :y
  attr_reader :ap
  attr_accessor :hp

  def initialize(type, x, y)
    @type, @x, @y = type, x, y
    @ap = 3
    @hp = 200
  end

  def char
    type.to_s[0].upcase
  end

  def foe_type
    @type == :elf ? :goblin : :elf
  end
end

class Distances
  attr_reader :paths

  def initialize(game, entity)
    @game, @entity = game, entity

    @grid = @game.map.map do |r|
      r.map { |c| c == '.' ? FAR : SOLID }
    end
    game.entities.each { |a| @grid[a.y][a.x] = SOLID unless entity == a }

    @paths = {}

    trace(0, entity.x, entity.y, [])
  end

  def debug
    @grid.each do |row|
      row.each do |col|
        case col
        when -1
          print "##"
        when FAR
          print ".."
        else
          print "%0.2d" % col
        end
        print " "
      end
      print "\n"
    end
  end

  def trace(steps, x, y, path)
    val = @grid[y][x]
    return if val <= steps
    path = path.dup << [x, y]

    # Store notable paths
    READING.find do |ord|
      if entity = @game.entity_at(x + ord[0], y + ord[1], type: @entity.foe_type)
        pos = hash(x, y)
        if existing_path = @paths[pos]
          @paths[pos] = path if existing_path.size > path.size
        else
          @paths[pos] = path
        end
      end
    end

    @grid[y][x] = steps
    READING.each { |ord| trace(steps + 1, x + ord[0], y + ord[1], path) }
  end

  def path_to(x, y)
    @paths[hash(x, y)]
  end
end

class Game

  attr_reader :map, :entities, :turn

  def initialize(input)
    @map = []
    @entities = []
    @entity_map = nil
    @entities_by_type = nil
    @turn = 0

    input.each_line.with_index do |l, y|
      row = []
      l.chomp.chars.each_with_index do |c, x|
        tile = '.'
        case c
        when 'E'
          add_entity(:elf, x, y)
        when 'G'
          add_entity(:goblin, x, y)
        when '#'
          tile = '#'
        end
        row << tile
      end
      @map << row
    end
    @width = @map[0].size
    @height = @map.size
  end

  def add_entity(type, x, y)
    @entities << Entity.new(type, x, y)
  end

  def debug
    sort_entities

    @map.each_with_index do |row, y|
      row.each_with_index do |col, x|
        if e = entity_at(x, y)
          print e.char
        else
          print col
        end
      end
      print "\n"
    end

    p @entities.map { |e| "#{e.type.upcase[0]} -> #{e.hp}" }
    # puts "elves: #{@entities.select { |e| e.type == :elf }.map { |e| e.hp }}"
    # puts "goblins: #{@entities.select { |e| e.type == :goblin }.map { |e| e.hp }}"
  end

  def tick
    sort_entities
    @entities.each do |e|
      foes_left = @entities_by_type[e.foe_type].select{ |f| f.hp > 0 }.size
      return true if foes_left == 0
      next if e.hp <= 0
      next if attack_turn(e)

      move_turn(e)
      attack_turn(e)
    end
    @turn += 1
  end

  def move_turn(entity)
    distances = Distances.new(self, entity)
    shortest_path = nil

    (@entities_by_type[entity.foe_type] || []).each do |foe|
      if foe.hp > 0
        READING.each do |ord|
          if path = distances.path_to(foe.x + ord[0], foe.y + ord[1])
            shortest_path = path if shortest_path.nil? || path.size < shortest_path.size
          end
        end
      end
    end

    if shortest_path && move_to = shortest_path[1]
      move_entity(entity, move_to[0], move_to[1])
    end
  end

  def attack_turn(entity)
    weakest = nil
    READING.each do |ord|
      if foe = entity_at(entity.x + ord[0], entity.y + ord[1], type: entity.foe_type)
        weakest = foe if weakest.nil? || foe.hp < weakest.hp
      end
    end

    weakest.hp -= entity.ap if weakest
    !!weakest
  end

  def move_entity(e, x, y)
    e.x = x
    e.y = y
    update_caches
  end

  def entity_at(x, y, opts = {})
    result = @entity_map[hash(x, y)]

    return nil if result.nil?
    return if result.hp <= 0

    if opts[:type] && result.type != opts[:type]
      return nil
    end

    result
  end

  def check_done
    entities.delete_if { |e| e.hp <= 0 }

    elf_count = 0
    goblin_count = 0
    hps = 0

    entities.each do |e|
      elf_count += 1 if e.type == :elf
      goblin_count += 1 if e.type == :goblin
      hps += e.hp
    end

    if elf_count == 0 || goblin_count == 0
      puts "#{elf_count == 0 ? "Goblins" : "Elves" } win!"
      debug
      p [turn, hps, turn * hps]
      return true
    end
  end

protected

  def update_caches
    @entity_map = {}
    @entities_by_type = {}
    @entities.each do |e|
      @entity_map[hash(e.x, e.y)] = e
      @entities_by_type[e.type] ||= []
      @entities_by_type[e.type] << e
    end
  end

  def sort_entities
    @entities.sort_by! { |a| [a.y, a.x] }
    update_caches
  end

end

# game = Game.new(inputs[9])
game = Game.new(File.read("day15.input"))

done = false
while !done
  puts game.turn
  game.debug
  game.tick
  done = game.check_done
end
