input = File.read("day10.input")

points = input.each_line.map do |l|
  l.sub("position=<", " ").sub("> velocity=<", " ").sub(">", "").split.map(&:to_i)
end

min_height = Float::INFINITY

(0..100_000).each do |t|
  bounds = [Float::INFINITY, Float::INFINITY, -Float::INFINITY, -Float::INFINITY]

  hits = {}
  points.each do |p|
    x = p[0] + (p[2] * t)
    y = p[1] + (p[3] * t)

    bounds[0] = x if x < bounds[0]
    bounds[2] = x if x > bounds[2]
    bounds[1] = y if y < bounds[1]
    bounds[3] = y if y > bounds[3]

    hits[y] ||= {}
    hits[y][x] = 1
  end

  height = bounds[3] - bounds[1]

  min_height = height if height < min_height

  if (height == 9)
    puts t
    (bounds[1]..bounds[3]).each do |y|
      (bounds[0]..bounds[2]).each do |x|
        print (hits[y] && hits[y][x]) ? "#" : '.'
      end
      print "\n"
    end
    exit
  end
end
