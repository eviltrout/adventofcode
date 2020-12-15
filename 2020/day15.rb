data = [20,9,11,0,1,2]

last_seen = {}
data[0..-1].each.with_index { |x, i| last_seen[x] = i + 1 }
pending = data[-1]

last = -1
(data.size+1..30000000).each do |t|
  idx = last_seen[pending]
  last_seen[pending] = t - 1
  pending = idx.nil? ? 0 : t - idx - 1
end
puts pending
