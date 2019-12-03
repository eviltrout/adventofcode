input = File.read('day03.input')

v_lines = []
h_lines = []

wires = input.split("\n")

x, y = 0, 0
wires[0].split(",").each do |inst|
  dir, length = inst[0], inst[1..-1].to_i

  case dir
  when 'U'
    v_lines << [x, y - length, y]
    y = y - length
  when 'D'
    v_lines << [x, y, y + length]
    y = y + length
  when 'L'
    h_lines << [y, x - length, x]
    x = x - length
  when 'R'
    h_lines << [y, x, x + length]
    x = x + length
  end
end

def intersect(lines, a, b0, b1)
  distances = []
  lines.each do |l|
    if l[0] > b0 && l[0] < b1 && (a > l[1] && a < l[2])
      distances << (l[0].abs + a.abs)
    end
  end
  distances.min
end

x, y = 0, 0
distances = []
d = nil
wires[1].split(",").each do |inst|
  dir, length = inst[0], inst[1..-1].to_i

  case dir
  when 'U'
    distances << d if d = intersect(h_lines, x, y - length, y)
    y = y - length
  when 'D'
    distances << d if d = intersect(h_lines, x, y, y + length)
    y = y + length
  when 'L'
    distances << d if d = intersect(v_lines, y, x - length, x)
    x = x - length
  when 'R'
    distances << d if d = intersect(v_lines, y, x, x + length)
    x = x + length
  end
end
puts distances.inspect
puts distances.min

