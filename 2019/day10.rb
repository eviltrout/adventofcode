require 'set'

input = File.read("day10.input")
width = height = 0
roids = []

map = []
input.each_line.with_index do |l, j|
	row = []
	l.chomp!
	width = l.size
	height += 1

	map << l.chars
	l.each_char.with_index do |c, i|
		roids << [i, j] if c == '#'
	end
end

def vec(p0, p1)
	x0, y0, x1, y1 = p0[0], p0[1], p1[0], p1[1]
	xs = (x1 - x0)
	ys = (y1 - y0)
	len = Math.sqrt((xs*xs) + (ys*ys))
	[(xs / len).round(5), (ys / len).round(5)]
end

def ang(p0, p1)
	res = (Math.atan2(p0[1] - p1[1], p0[0] - p1[0]) * 180 / Math::PI) - 90
	res += 360 while res < 0
  res
end

max = 0
max_val = -1
roids.each do |r0|
	vecs = Set.new
	roids.each do |r1|
		next if r0 == r1
		vecs << vec(r0, r1)
	end
  if vecs.size > max
		max_val = r0
		max = vecs.size
	end
end
puts max_val.inspect
puts max

angle = 0

r0 = max_val
roids.delete(r0)

rads = {}
roids.each do |r1|
	rad = ang(r0, r1)
	rads[rad] ||= []
	rads[rad] << { p: r1, d: Math.sqrt((r0[0] - r1[0])**2 + (r0[1] - r1[1]) ** 2) }
end

sorted = rads.keys.sort
i = 0
c = 1
loop do
	hits = rads[sorted[i]]

	unless hits.empty?
		min_hit = hits.min_by { |h| h[:d] }
		hits.delete(min_hit)
		zap = min_hit[:p]
		roids.delete(zap)
		if c == 200
			puts "#{c}: #{zap.inspect} -> #{zap[0] * 100 + zap[1]}"
			exit
		end
		c += 1
	end

	i += 1
	i = 0 if i >= sorted.size
end
