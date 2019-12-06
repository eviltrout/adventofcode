require 'set'

input = File.read("day06.input")

class Things
  def initialize
    @things = {}
  end

  def get(id)
    unless thing = @things[id]
      thing = @things[id] = Thing.new(id)
    end
    thing
  end

  def build(input)
    input.split.each do |o|
      src, dest = o.split(")")
      t0, t1 = get(src), get(dest)
      t0.children << t1
      t1.parent = t0
    end
  end

  def score_all
    score(get('COM'), 0)
  end

  def score(thing, depth)
    return depth + thing.children.sum { |c| score(c, depth + 1) }
  end

  def path_to(id)
    path = []
    thing = get(id)
    while !thing.parent.nil?
      thing = thing.parent
      path << thing.id
    end
    path
  end
end

class Thing
  def initialize(id)
    @id = id
    @children = Set.new
  end
  attr_reader :id
  attr_accessor :parent
  attr_accessor :children
end

things = Things.new
things.build(input)

puts things.score_all
p0, p1 = things.path_to('YOU'), things.path_to('SAN')

while p0.last == p1.last
  p0.pop
  p1.pop
end

puts p0.size + p1.size
