require 'set'

class Machine
  attr_accessor :input, :output, :last_output

  def initialize(code)
    @prog = code.dup
    @i = 0
    @state = :running
    @input = []
    @output = []
    @last_output = nil
    @relative_base = 0
  end

  def queue_input(val)
		val = val.ord if val.is_a?(String)
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

code = File.read("day23.input").split(',').map(&:to_i)

machines = {}
(0...50).each do |id|
	m = Machine.new(code)
	m.queue_input(id)
	machines[id] = m
end

last_y = nil
nat = []
all_machines = machines.values.to_a
idle_count = 0
loop do
	sent = false
	all_machines.each do |m|
		m.advance
		if m.output.size == 3
			id, x, y = m.output_n(3)

			if id == 255
				nat = [x, y]
			else
				sent = true
				dest = machines[id]
				dest.queue_input(x)
				dest.queue_input(y)
			end
		end
	end
	idle_count += 1 unless sent
	if (idle_count > 5000)
		machines[0].queue_input(nat[0])
		machines[0].queue_input(nat[1])
		puts "#{last_y} => #{nat[1]}"
		break if last_y == nat[1]
		last_y = nat[1]
		idle_count = 0
  end
end

