input = "cpy 41 a\ninc a\ninc a\ndec a\njnz a 2\ndec a"
input = File.read("day12.input")

ops = input.split("\n")
ip = 0
registers = {'a' => 0, 'b' => 0, 'c' => 0, 'd' => 0}

while ip < ops.size
  op = ops[ip].split

  case op[0]
  when 'cpy'
    registers[op[2]] = registers[op[1]] || op[1].to_i
  when 'inc'
    registers[op[1]] += 1
  when 'dec'
    registers[op[1]] -= 1
  when 'jnz'
    ip += (op[2].to_i - 1) if (registers[op[1]] || op[1].to_i) != 0
  end

  ip += 1
end
puts registers.inspect


