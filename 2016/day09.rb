# input = "ADVENT\nA(1x5)BC\n(3x3)XYZ\nA(2x2)BCD(2x2)EFG\n(6x1)(1x3)A\nX(8x2)(3x3)ABCY"
# input = "(3x3)XYZ\nX(8x2)(3x3)ABCY\n(27x12)(20x12)(13x14)(7x10)(1x12)A\n(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN"
input = File.read("day09.input")

def p1(l)
  result = ""
  while idx = l.index(/\((\d+)x(\d+)\)/)
    code, c, n = *Regexp.last_match
    remaining = l[idx+code.size..-1]
    result << l[0...idx] << (remaining[0...c.to_i] * n.to_i)
    l = remaining[c.to_i..-1]
  end
  result << l
  result.size
end

def p2(str)
  if idx = str.index(/\((\d+)x(\d+)\)/)
    code, c, n = *Regexp.last_match
    remaining = str[idx+code.size..-1]
    return idx + (p2(remaining[0..c.to_i-1]) * n.to_i) + p2(remaining[c.to_i..-1])
  else
    return str.size
  end
end

input.split("\n").each do |l|
  puts "p1: #{p1(l)}"
  puts "p2: #{p2(l)}"
end
