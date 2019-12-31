require 'set'

class Machine
  attr_accessor :input, :output, :last_output

  def initialize(code)
    @code = code
    reset!
  end

  def queue_input(val)
		val = val.ord if val.is_a?(String)
    @input << val
  end

  def reset!
    @prog = @code.dup
    @i = 0
    @state = :running
    @input = []
    @output = []
    @last_output = nil
    @relative_base = 0
  end

  def advance
    return unless @state == :running
    opcodes = @prog[@i].digits

    cmd = ((opcodes[1] || 0) * 10) + opcodes[0]
    types = opcodes[2..-1] || []

    case cmd
    when 1..2
      params = get_params(2, types)
      write(types, 3, cmd == 1 ? params[0] + params[1] : params[0] * params[1])
      @i += 4
    when 3
			val = -1
      unless @input.empty?
				val = @input.shift
			end
      write(types, 1, val)
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
      write(types, 3, params[0] < params[1] ? 1 : 0)
      @i += 4
    when 8
      params = get_params(2, types)
      write(types, 3, params[0] == params[1] ? 1 : 0)
      @i += 4
    when 9
      params = get_params(1, types)
      @relative_base += params[0]
      @i += 2
    when 99
      @state = :ended
    else
      puts "Error, invalid code #{cmd}"
      return
    end
  end

  def output_n(n)
    while running? && @output.size < n
      advance
    end

		@output.shift(n)
  end

  def run_until_output
    advance while running? && @output.empty?
    @output.pop
  end

  def run_until_finished
    advance while running?
    @output
  end

	def poke(a, v)
		@prog[a] = v
	end

  def running?
    @state == :running
  end

  def ended?
    @state == :ended
  end

  def dump_output
    @output.shift(@output.size)
  end


protected
  def write(types, offset, val)
    type = types[offset - 1] || 0
    index = @prog[@i + offset]
    if type == 0
      @prog[index] = val
    else
      @prog[@relative_base + index] = val
    end
  end

  def get_params(count, types)
    result = []

    count.times do |c|
      val = @prog[@i + c + 1]
      type = types[c] || 0

      case type
      when 0
        val = @prog[val]
      when 2
        val = @prog[@relative_base + val]
      end

      result << (val || 0)
    end
    result
  end
end


machine = Machine.new(File.read("day19.input").split(',').map(&:to_i))

buffer = []

(0...50).each do |y|
  row = []
  (0...50).each do |x|
    machine.reset!
    machine.queue_input(x)
    machine.queue_input(y)
    result = machine.run_until_output
    row << result
  end
  buffer << row
end

p buffer.sum { |row| row.sum }

search = 2000
lowest_y = search
highest_y = 0

(0...search).each do |y|
  machine.reset!
  machine.queue_input(search)
  machine.queue_input(y)
  val = machine.run_until_output
  if val == 1
    lowest_y = y if y < lowest_y
    highest_y = y if y > highest_y
  end
end

def least_x(y, slope)
  2000.times { |x| return x if (x * slope).floor == y }
end

slope = (highest_y / search.to_f)
(0..1000).each do |y|
  x = least_x(y, slope)

  machine.reset!
  machine.queue_input(x + 99)
  machine.queue_input(y - 99)
  val = machine.run_until_output
  if val == 1
    return puts x * 10000 + (y - 99)
  end
end
