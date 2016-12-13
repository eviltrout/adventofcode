
@input = 1362

def solid(x, y)
  i = (x*x + 3*x + 2*x*y + y + y*y) + @input
  i = i - ((i >> 1) & 0x55555555)
  i = (i & 0x33333333) + ((i >> 2) & 0x33333333)
  i = (i + (i >> 4)) & 0x0F0F0F0F
  i = i + (i >> 8)
  i = i + (i >> 16)
  ((i & 0x0000003F) % 2 == 1)
end


def fill(x, y, filled, path)
  return if x < 0 || y < 0 || path.size > 50 || path.include?("#{x}-#{y}") || solid(x, y)
  path += ["#{x}-#{y}"]
  filled[y][x] = 1
  fill(x-1, y, filled, path)
  fill(x+1, y, filled, path)
  fill(x, y-1, filled, path)
  fill(x, y+1, filled, path)
end

filled = Array.new(100) { Array.new(100, 0) }
fill(1, 1, filled, [])

(0...40).each do |y|
  (0...32).each do |x|
    if filled[y][x] == 1
      print '-'
    else
      print(solid(x, y) ? '#' : '.')
    end
  end
  puts
end

count = filled.map{|y| y.reduce(:+)}.reduce(:+)
p count
