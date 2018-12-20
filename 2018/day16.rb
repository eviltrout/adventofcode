input = File.read("day16.input")

OP_CODES = [
  :addi,
  :addr,
  :muli,
  :mulr,
  :bani,
  :banr,
  :bori,
  :borr,
  :seti,
  :setr,
  :gtir,
  :gtri,
  :gtrr,
  :eqir,
  :eqri,
  :eqrr,
]

def exec(registers, op_code, a, b, c)
  result = registers.dup
  case op_code
  when :addi
    result[c] = registers[a] + b
  when :addr
    result[c] = registers[a] + registers[b]
  when :muli
    result[c] = registers[a] * b
  when :mulr
    result[c] = registers[a] * registers[b]
  when :bani
    result[c] = registers[a] & b
  when :banr
    result[c] = registers[a] & registers[b]
  when :bori
    result[c] = registers[a] | b
  when :borr
    result[c] = registers[a] | registers[b]
  when :seti
    result[c] = a
  when :setr
    result[c] = registers[a]
  when :gtir
    result[c] = a > registers[b] ? 1 : 0
  when :gtri
    result[c] = registers[a] > b ? 1 : 0
  when :gtrr
    result[c] = registers[a] > registers[b] ? 1 : 0
  when :eqir
    result[c] = a == registers[b] ? 1 : 0
  when :eqri
    result[c] = registers[a] == b ? 1 : 0
  when :eqrr
    result[c] = registers[a] == registers[b] ? 1 : 0
  else
    raise "#{op_code} not found!"
  end

  result
end

before, instructions, after = nil
matches = {}

program = []
count = 0
num = 0

learning = true
last = nil
input.each_line do |l|

  l = l.chomp

  if learning
    if l =~ /Before: +\[(\d+, \d+, \d+, \d+)\]$/
      before = Regexp.last_match[1].split(", ").map(&:to_i)
    elsif l =~ /^(\d+ \d+ \d+ \d+)$/
      instructions = Regexp.last_match[1].split(" ").map(&:to_i)
    elsif l =~ /After: +\[(\d+, \d+, \d+, \d+)\]/
      after = Regexp.last_match[1].split(", ").map(&:to_i)
    elsif l.empty?
      op_code, a, b, c = instructions
      op_codes = OP_CODES.select { |op| exec(before, op, a, b, c) == after }
      op_codes.each do |code|
        matches[code] ||= Hash.new { 0 }
        matches[code][op_code] += 1
      end
      count += 1 if op_codes.size >= 3

      learning = false if last.empty?
    end
  elsif !l.empty?
    program << l.split(" ").map(&:to_i)
  end

  last = l
  num += 1
end

codex = {}
while !matches.empty?
  matches.each { |code, counts| codex[code] = counts.keys[0] if counts.size == 1 }

  codex.keys.each do |i|
    matches.delete(i)
    matches.each { |k, v| v.delete(codex[i]) }
  end
end

puts "codex: #{codex.inspect}"
puts count

find_code = codex.invert
registers = [0, 0, 0, 0]
program.each do |codes|
  op_code, a, b, c = codes
  registers = exec(registers, find_code[op_code], a, b, c)
end
p registers

def assert_op(op, regs, a, b, c, after)
  result = exec(regs, op, a, b, c)
  puts "failed: #{op}; wanted: #{after.inspect}, got: #{result.inspect}" unless result == after
rescue
  puts "failed: #{op}"
  raise
end

def tests
  data = [1, 2, 3, 5]
  data_dup = [2, 2, 3, 5]
  assert_op(:addi, data, 3, 7, 0, [12, 2, 3, 5])
  assert_op(:addi, data, 0, 1, 3, [1, 2, 3, 2])
  assert_op(:addr, data, 0, 2, 0, [4, 2, 3, 5])
  assert_op(:addr, data, 1, 2, 1, [1, 5, 3, 5])
  assert_op(:muli, data, 2, 2, 0, [6, 2, 3, 5])
  assert_op(:mulr, data, 1, 3, 2, [1, 2, 10, 5])
  assert_op(:bani, data, 2, 2, 0, [2, 2, 3, 5])
  assert_op(:banr, data, 0, 1, 2, [1, 2, 0, 5])
  assert_op(:bori, data, 2, 4, 1, [1, 7, 3, 5])
  assert_op(:borr, data, 2, 1, 0, [3, 2, 3, 5])
  assert_op(:seti, data, 5, 1, 0, [5, 2, 3, 5])
  assert_op(:seti, data, 4, 0, 0, [4, 2, 3, 5])
  assert_op(:setr, data, 3, 0, 1, [1, 5, 3, 5])
  assert_op(:setr, data, 3, 0, 3, [1, 2, 3, 5])
  assert_op(:gtir, data, 3, 1, 3, [1, 2, 3, 1])
  assert_op(:gtir, data, 2, 1, 3, [1, 2, 3, 0])
  assert_op(:gtri, data, 2, 4, 0, [0, 2, 3, 5])
  assert_op(:gtri, data, 2, 2, 0, [1, 2, 3, 5])
  assert_op(:gtrr, data, 1, 0, 2, [1, 2, 1, 5])
  assert_op(:gtrr, data, 0, 1, 2, [1, 2, 0, 5])
  assert_op(:eqir, data, 2, 1, 1, [1, 1, 3, 5])
  assert_op(:eqir, data, 1, 1, 1, [1, 0, 3, 5])
  assert_op(:eqri, data, 1, 2, 1, [1, 1, 3, 5])
  assert_op(:eqri, data, 1, 1, 1, [1, 0, 3, 5])
  assert_op(:eqrr, data, 0, 1, 2, [1, 2, 0, 5])
  assert_op(:eqrr, data_dup, 0, 1, 2, [2, 2, 1, 5])
  assert_op(:addi, [3, 2, 1, 1], 2, 1, 2, [3, 2, 2, 1])
end

tests
