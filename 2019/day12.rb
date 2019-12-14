require 'digest/sha1'

input = <<~MOONS
<x=-19, y=-4, z=2>
<x=-9, y=8, z=-16>
<x=-4, y=5, z=-11>
<x=1, y=9, z=-13>
MOONS

class Moon
  attr_accessor :pos, :velocity

  def initialize(pos)
    @pos = pos
    @velocity = [0, 0, 0]
  end

  def move
    (0..2).each { |i| @pos[i] += @velocity[i] }
  end

  def energy
    @pos.map(&:abs).sum * @velocity.map(&:abs).sum
  end

end

moons = input.split("\n").map { |m| Moon.new(m.scan(/\-?\d+/).map(&:to_i)) }
seen = {}

step = 1

require 'set'
seen = [Set.new, Set.new, Set.new]
loops = [nil, nil, nil]

loop.each do
  moons.product(moons) do |m|
    next if m[0] == m[1]
    (0..2).each do |i|
      next if m[0].pos[i] == m[1].pos[i]
      m[0].velocity[i] += (m[0].pos[i] < m[1].pos[i]) ? 1 : -1
    end
  end
  moons.each(&:move)
  total = moons.sum { |m| m.energy }

  (0..2).each do |l|
    if loops[l].nil?
      hash = ""
      moons.each_with_index { |m, i| hash = Digest::SHA1.hexdigest(hash + "#{m.pos[l]},#{m.velocity[l]}") }
      if seen[l].include?(hash)
        loops[l] = (step - 1)
      end
      seen[l] << hash
    end
  end

  break if loops[0] && loops[1] && loops[2]
  puts total if step === 1000
  step += 1
end

puts loops.inspect
puts loops.reduce(1, :lcm)
