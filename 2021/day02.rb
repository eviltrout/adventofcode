vals = File.read(File.basename(__FILE__, ".rb") + ".input")

h = a = d = 0
vals.split("\n").each do |i|
  cmd, n = i.split
  n = n.to_i
  if cmd == "forward"
    h += n
    d += (a * n)
  else
    a += (cmd == "up") ? -n : n
  end
end

puts h * a
puts h * d


