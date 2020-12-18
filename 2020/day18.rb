data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
1 + (2 * 3) + (4 * (5 + 6))
2 * 3 + (4 * 5)
5 + (8 * 3 + 9 + 3 * 4 * 3)
5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))
((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2
DATA

def find_end(x, idx)
  count = 1
  x[idx+1..-1].each_char.with_index do |c, rp|
    count += 1 if c == '('
    count -= 1 if c == ')'
    return rp+idx+1 if count == 0
  end
end

def expr(x, prec=nil)
  while lp = x.index("(")
    rp = find_end(x, lp)
    result = expr(x[lp+1..rp-1], prec)
    x = (lp == 0 ? '' : x[0..lp-1]) + result.to_s + x[rp+1..-1]
  end
  tokens = x.split(' ')
  while tokens.size > 1
    index = prec == '+' && tokens.index('+') ? tokens.index('+') - 1 : 0
    tokens[index..index+2] = tokens[index].to_i.send(tokens[index+1], tokens[index+2].to_i)
  end
  tokens[0]
end

puts data.split("\n").sum { |x| expr(x) }
puts data.split("\n").sum { |x| expr(x, '+') }
