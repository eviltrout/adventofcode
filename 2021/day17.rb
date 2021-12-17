require 'set'

input = 'target area: x=117..164, y=-140..-89'
target = input.scan(/\-?\d+/).map(&:to_i)

class Entity
  attr_accessor :x, :y
  attr_accessor :vx, :vy

  def initialize(vx, vy)
    @x = @y = 0
    @vx, @vy = vx, vy
  end
end

def simulate(e, target)
  maxy = e.y

  loop do |step|
    return [true, maxy] if e.x >= target[0] && e.x <= target[1] && e.y >= target[2] && e.y <= target[3]
    return false if e.vy < 0 && e.y < target[2] * 2

    e.x += e.vx
    e.y += e.vy
    maxy = e.y if e.y > maxy

    if e.vx > 0
      e.vx -= 1
    elsif e.vx < 0
      e.vx += 1
    end
    e.vy -= 1
  end
  false
end

maxy = target[3]
vels = Set.new
vxrange = (0..target[1])
vyrange = (target[2]..target[2..3].min.abs)

vxrange.each do |vx|
  vyrange.each do |vy|
    success, my = simulate(Entity.new(vx, vy), target)
    if success
      vels << [vx, vy]
      if my > maxy
        maxy = my
      end
    end
  end
end
p vels.size
puts maxy
