require 'pry'

class Machine
  attr_accessor :input, :output, :last_output

  def initialize(code)
    @prog = code.dup
    @i = 0
    @state = :running
    @input = []
    @output = []
    @last_output = nil
  end

  def queue_input(val)
    @input << val
  end

  def advance
    return unless @state == :running
    opcodes = @prog[@i].digits

    cmd = ((opcodes[1] || 0) * 10) + opcodes[0]
    types = opcodes[2..-1] || []

    case cmd
    when 1..2
      params = get_params(2, types)
      @prog[@prog[@i + 3]] = cmd == 1 ? params[0] + params[1] : params[0] * params[1]
      @i += 4
    when 3
      return if @input.empty?
      val = @input.shift
      @prog[@prog[@i + 1]] = val
      @i += 2
    when 4
      params = get_params(1, types)
      @output << params[0]
      @last_output = params[0]
      @i += 2
    when 5
      params = get_params(2, types)
      @i = params[0] != 0 ? params[1] : @i + 3
    when 6
      params = get_params(2, types)
      @i = params[0] == 0 ? params[1] : @i + 3
    when 7
      params = get_params(2, types)
      @prog[@prog[@i + 3]] = params[0] < params[1] ? 1 : 0
      @i += 4
    when 8
      params = get_params(2, types)
      @prog[@prog[@i + 3]] = params[0] == params[1] ? 1 : 0
      @i += 4
    when 99
      @state = :ended
    else
      puts "Error, invalid code #{cmd}"
      return
    end
  end

  def run_until_output
    advance while running? && @output.empty?
    @output.pop
  end

  def running?
    @state == :running
  end

  def ended?
    @state == :ended
  end

protected
  def get_params(count, types)
    result = []

    count.times do |c|
      val = @prog[@i + c + 1]
      type = types[c] || 0
      val = @prog[val] if type == 0
      result << val
    end
    result
  end
end

input = File.read("day07.input")
code = input.split(",").map(&:to_i)

# Part 1
max_output = 0
[0, 1, 2, 3, 4].permutation.each do |perm|
  last_output = 0

  perm.each do |p|
    machine = Machine.new(code)
    machine.queue_input(p)
    machine.queue_input(last_output)
    last_output = machine.run_until_output
    max_output = last_output if last_output > max_output
  end
end
puts max_output

# Part 2
max_output = 0
[5, 6, 7, 8, 9].permutation.each do |perm|
  machines = perm.map do |p|
    m = Machine.new(code)
    m.queue_input(p)
    m
  end

  c = 0
  last_output = 0
  loop do
    if machines.all? { |m| m.ended? }
      if machines[-1].last_output > max_output
        max_output = machines[-1].last_output
      end
      break
    else
      machines[c].queue_input(last_output)
      if result = machines[c].run_until_output
        last_output = result
      end
      c += 1
      c = 0 if c > 4
    end
  end
end
puts max_output
