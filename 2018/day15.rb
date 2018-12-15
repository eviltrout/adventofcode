FAR = 99
SOLID = -1

inputs = []

inputs << <<~DATA
#######
#E..G.#
#...#.#
#.G.#G#
#######
DATA

inputs << <<~DATA
#######
#.E...#
#.....#
#...G.#
#######
DATA

inputs << <<~DATA
#############
#E..........#
###########.#
#G..........#
#############
DATA

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

inputs << <<~DATA
##############################################
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#.....................E......................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
#............................................#
##############################################
DATA

def hash(x, y)
  (y * 10000) + x
end

class Entity
  attr_reader :type
  attr_accessor :x, :y

  def initialize(type, x, y)
    @type, @x, @y = type, x, y
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
        when 99
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
    return if val < steps

    path = path.dup << [x, y]

    # Store notable paths
    if @game.entity_at(x, y - 1, type: @entity.foe_type) ||
        @game.entity_at(x - 1, y, type: @entity.foe_type) ||
        @game.entity_at(x + 1, y, type: @entity.foe_type) ||
        @game.entity_at(x, y + 1, type: @entity.foe_type)

      pos = hash(x, y)
      if existing_path = @paths[pos]
        @paths[pos] = path if existing_path.size > path.size
      else
        @paths[pos] = path
      end
    end

    @grid[y][x] = steps

    steps += 1
    trace(steps, x, y - 1, path)
    trace(steps, x - 1, y, path)
    trace(steps, x + 1, y, path)
    trace(steps, x, y + 1, path)
  end

  def path_to(x, y)
    @paths[hash(x, y)]
  end
end

class Game

  attr_reader :map, :entities

  def initialize(input)
    @map = []
    @entities = []
    @entity_map = nil
    @entities_by_type = nil

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
    sort_entities if @entity_map.nil?

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
  end

  def tick

    @entities.each do |e|
      sort_entities
      turn(e)
    end
  end

  def turn(entity)
    distances = Distances.new(self, entity)
    shortest_path = nil

    @entities_by_type[entity.foe_type].each do |foe|
      if path = distances.path_to(foe.x, foe.y - 1)
        shortest_path = path if shortest_path.nil? || path.size < shortest_path.size
      end
      if path = distances.path_to(foe.x - 1, foe.y)
        shortest_path = path if shortest_path.nil? || path.size < shortest_path.size
      end
      if path = distances.path_to(foe.x + 1, foe.y)
        shortest_path = path if shortest_path.nil? || path.size < shortest_path.size
      end
      if path = distances.path_to(foe.x, foe.y + 1)
        shortest_path = path if shortest_path.nil? || path.size < shortest_path.size
      end
    end

    if shortest_path && move_to = shortest_path[1]
      move_entity(entity, move_to[0], move_to[1])
    end
  end

  def move_entity(e, x, y)
    e.x = x
    e.y = y
    update_caches
  end

  def entity_at(x, y, opts = {})
    result = @entity_map[hash(x, y)]
    return nil if result.nil?

    if opts[:type] && result.type != opts[:type]
      return nil
    end

    result
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

game = Game.new(inputs[3])
game.debug
game.tick
game.debug
game.tick
game.debug
game.tick
game.debug
