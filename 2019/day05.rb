require 'pry'

def get_params(prog, i, count, types)
  result = []

  count.times do |c|
    val = prog[i + c + 1]
    type = types[c] || 0
    val = prog[val] if type == 0
    result << val
  end
  result
end

def run(code, input, output)
  prog = code.dup

  i = 0
  loop do
    opcodes = prog[i].digits

    cmd = ((opcodes[1] || 0) * 10) + opcodes[0]
    types = opcodes[2..-1] || []

    case cmd
    when 1..2
      params = get_params(prog, i, 2, types)
      prog[prog[i + 3]] = cmd == 1 ? params[0] + params[1] : params[0] * params[1]
      i += 4
    when 3
      val = input.call
      prog[prog[i + 1]] = val
      i += 2
    when 4
      params = get_params(prog, i, 1, types)
      output.call(params[0])
      i += 2
    when 5
      params = get_params(prog, i, 2, types)
      i = params[0] != 0 ? params[1] : i + 3
    when 6
      params = get_params(prog, i, 2, types)
      i = params[0] == 0 ? params[1] : i + 3
    when 7
      params = get_params(prog, i, 2, types)
      prog[prog[i + 3]] = params[0] < params[1] ? 1 : 0
      i += 4
    when 8
      params = get_params(prog, i, 2, types)
      prog[prog[i + 3]] = params[0] == params[1] ? 1 : 0
      i += 4
    when 99
      return prog
    else
      puts "Error, invalid code #{cmd}"
      return
    end
  end
end

code = File.read("day05.input").split(",").map(&:to_i)
run(code, ->() { 5 }, ->(x) { puts "OUTPUT: #{x}" })
