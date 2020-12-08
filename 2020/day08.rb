data = File.read(File.basename(__FILE__, ".rb") + ".input")

test_data = <<~DATA
nop +0
acc +1
jmp +4
acc +3
jmp -3
acc -99
acc +1
jmp -4
acc +6
DATA

program = data.split("\n").map { |i| i.split(" ") }

def run(program, swap = nil)
  return false if swap && !%w(jmp nop).include?(program[swap][0])
  ip = acc = 0
  visited = {}
  while !visited[ip]
    op, i = program[ip]

    op = op == "jmp" ? "nop" : "jmp" if ip == swap
    visited[ip] = true

    acc += i.to_i if op == "acc"
    ip += (i.to_i - 1) if op == "jmp"
    ip += 1
    return [true, acc] if ip == program.size
  end
  [false, acc]
end


puts run(program)[1]

result = false
program.size.times do |x|
  result, acc = run(program, x)
  if result
    puts acc
    break
  end
end
