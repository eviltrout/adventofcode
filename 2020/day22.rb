require 'set'

data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
DATA

cards = data.split("\n\n").map { |p| p.split(?\n)[1..-1].map(&:to_i) }
c0, c1 = cards[0].dup, cards[1].dup

while !c0.empty? && !c1.empty?
  p0, p1 = c0.shift, c1.shift

  if p0 > p1
    c0 << p0 << p1
  else
    c1 << p1 << p0
  end
end
p [c0, c1].flatten.reverse.each.with_index.sum { |x, i| x * (i + 1) }

def play_game(c0, c1)
  seen = Set.new

  while !c0.empty? && !c1.empty?
    return 0 unless seen.add?((c0 + [0] + c1).pack('c*'))

    p0, p1 = c0.shift, c1.shift
    winner = if c0.size >= p0 && c1.size >= p1
      play_game(c0.take(p0), c1.take(p1))[0]
    else
      p0 > p1 ? 0 : 1
    end

    if winner == 0
      c0 << p0 << p1
    else
      c1 << p1 << p0
    end
  end

  return c0.empty? ? [1, c1] : [0, c0]
end

winner, res = play_game(cards[0].dup, cards[1].dup)
p res.flatten.reverse.each.with_index.sum { |x, i| x * (i + 1) }
