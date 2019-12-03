input = File.read('day02.input').split(',').map(&:to_i)

def run(input, noun, verb)
  prog = input.dup
  prog[1] = noun
  prog[2] = verb

  i = 0
  loop do
    cmd = prog[i]

    if cmd == 1 || cmd == 2
      v0, v1, a = prog[prog[i + 1]], prog[prog[i + 2]], prog[i + 3]
      prog[a] = cmd == 1 ? v0 + v1 : v0 * v1
      i += 4
    elsif cmd == 99
      return prog[0]
    end
  end
end

# part 1
puts run(input, 12, 2)

(0..99).each do |noun|
  (0..99).each do |verb|
    val = run(input, noun, verb)
    if val == 19690720
      puts 100 * noun + verb
      exit
    end
  end
end
