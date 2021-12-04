vals = File.read(File.basename(__FILE__, ".rb") + ".input")

lines = vals.split("\n")
vals = lines.map { |x| x.to_i(2) }
bits = (lines[0].size-1).downto(0).map { |x| 2 ** x }

# Part A
ep = 0
bits.each do |mask|
  c = vals.count { |i| i & mask == mask }
  ep = ep | mask if (c >= vals.size - c) 
end

gam = ep ^ (1 << bits.size) - 1
puts ep * gam

# Part B
v0 = vals.dup
v1 = vals.dup
bits.each do |mask|
  if v0.size > 1
    c = v0.count { |i| i & mask == mask }
    if (c >= v0.size - c) 
      v0.delete_if { |x| x & mask != mask }
    else
      v0.delete_if { |x| x & mask == mask }
    end
  end

  if v1.size > 1
    c = v1.count { |i| i & mask == mask }
    if (c >= v1.size - c) 
      v1.delete_if { |x| x & mask == mask }
    else
      v1.delete_if { |x| x & mask != mask }
    end
  end
end

puts v0[0] * v1[0]
