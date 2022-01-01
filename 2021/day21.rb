require 'set'

input = [4, 3]

positions = [input[0] - 1, input[1] - 1]
scores = [0, 0]

x = 1
turns = 0
while scores[0] < 1000 && scores[1] < 1000
  turn = turns % 2
  roll = (3 * x + 3)
  x += 3
  positions[turn] = (positions[turn] + roll) % 10
  scores[turn] += positions[turn] + 1
  turns += 1
end
puts turns * 3 * scores.min

def dirac(cache, possible, p0score, p1score, p0pos, p1pos)
  key = "#{p0score}:#{p1score}:#{p0pos}:#{p1pos}"
  return cache[key] if cache[key]
  return [1, 0] if p0score >= 21
  return [0, 1] if p1score >= 21

  wins = [0, 0]
  possible.each do |x, n|
    p0n = (p0pos + x) % 10
    p0s = p0score + p0n + 1

    y, z = dirac(cache, possible, p1score, p0score + p0n + 1, p1pos, p0n)
    wins[1] += (y * n)
    wins[0] += (z * n)
  end

  cache[key] = wins
end

possible = Hash.new { 0 }
(1..3).each do |x|
  (1..3).each do |y|
    (1..3).each do |z|
      possible[x + y + z] += 1
    end
  end
end

cache = {}
p dirac(cache, possible, 0, 0, input[0]-1, input[1]-1).max

