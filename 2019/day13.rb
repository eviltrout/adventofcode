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
		@blocked = false
  end

  def queue_input(val)
    @input << val
  end

  def advance
    return unless @state == :running
    opcodes = @prog[@i].digits

		@blocked = false
    cmd = ((opcodes[1] || 0) * 10) + opcodes[0]
    types = opcodes[2..-1] || []

    case cmd
    when 1..2
      params = get_params(2, types)
      write(types, 3, cmd == 1 ? params[0] + params[1] : params[0] * params[1])
      @i += 4
    when 3
      if @input.empty?
				@blocked = true
				return
			end
      val = @input.shift
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
      return if blocked?
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

  def blocked?
    @blocked
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

machine = Machine.new(File.read('day13.input').split(',').map(&:to_i))
c = 0
while machine.running?
	_, _, tile_id = machine.output_n(3)
  c += 1 if tile_id == 2
end
puts c

machine = Machine.new(File.read('day13.input').split(',').map(&:to_i))
machine.poke(0, 2)

buffer = Array.new(22) { Array.new(50) }
score = 0
paddle = ball = 0
while machine.running?
  machine.queue_input(ball <=> paddle) if machine.blocked?
  x, y, tile_id = machine.output_n(3)
  if x
    if x == -1
      score = tile_id
    else
      buffer[y][x] = tile_id
      paddle = x if tile_id == 3
      ball = x if tile_id == 4
    end
  end
end
puts score
