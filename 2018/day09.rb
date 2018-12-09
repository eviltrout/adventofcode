class Marble
  attr_reader :id
  attr_accessor :clockwise, :counter_clockwise

  def initialize(id)
    @id = id
  end
end

start = Marble.new(0)
start.clockwise = start.counter_clockwise = start

scores = Hash.new { 0 }
players = 476
stop_at = 71657

current = start
stop_at.times.each do |x|
  next_id = x + 1
  if next_id > 0 && next_id % 23 == 0
    player = (x % players) + 1
    scores[player] += next_id

    7.times { current = current.counter_clockwise }
    scores[player] += current.id
    current.counter_clockwise.clockwise = current.clockwise
    current = current.clockwise
  else
    marble = Marble.new(next_id)
    prev_pos = current.clockwise
    next_pos = current.clockwise.clockwise

    marble.counter_clockwise = prev_pos
    marble.clockwise = next_pos
    prev_pos.clockwise = marble
    next_pos.counter_clockwise = marble
    current = marble
  end
end

p scores.values.max
