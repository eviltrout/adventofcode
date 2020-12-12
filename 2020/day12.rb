data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
F10
N3
F7
R90
F11
DATA

# news
DIRS = { 'N' => [0, -1], 'E' => [1, 0], 'S' => [0, 1], 'W' => [-1, 0] }

dir = 1
x = y = 0
data.split.each do |row|
  i, n = row[0], row[1..-1].to_i
  if i == 'L'
    dir = (dir - (n / 90)) % 4
  elsif i == 'R'
    dir = (dir + (n / 90)) % 4
  else
    d = DIRS[i] || DIRS.values[dir]
    x += (d[0] * n)
    y += (d[1] * n)
  end
end
puts x.abs + y.abs

wp = [10, -1]
x = y = 0
data.split.each do |row|
  i, n = row[0], row[1..-1].to_i

  if i == 'F'
    x += (wp[0] * n)
    y += (wp[1] * n)
  elsif i == 'L' || i == 'R'
    deg = (i == 'L' ? -1 : 1) *n * Math::PI / 180
    wp = [(Math.cos(deg) * wp[0] - Math.sin(deg) * wp[1]).round,
          (Math.sin(deg) * wp[0] + Math.cos(deg) * wp[1]).round]
  else
    wp[0] += (DIRS[i][0] * n)
    wp[1] += (DIRS[i][1] * n)
  end
end

puts x.abs + y.abs
