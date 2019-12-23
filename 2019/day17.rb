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
		@blocked = false
  end

  def queue_input(val)
		@blocked = false
		val = val.ord if val.is_a?(String)
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

	def run_until_blocked
		advance while running? && !blocked?
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

machine = Machine.new(File.read("day17.input").split(',').map(&:to_i))

buffer = []
row = []
width = height = 0
machine.run_until_finished
machine.output.each do |v|
	if v == 10
		width = row.size if row.size > width
		buffer << row
		row = []
	else
		row << v.chr
	end
end
height = buffer.size

params = 0
(0...height).each do |y|
	(0...width).each do |x|
		if buffer[y-1][x] == '#' &&
			buffer[y][x-1] == '#' &&
			buffer[y][x+1] == '#' &&
			buffer[y+1][x] == '#'
			print 'O'
			params += (x * y)
		else
			print buffer[y][x]
		end
	end
	print "\n"
end
puts params

machine = Machine.new(File.read("day17.input").split(',').map(&:to_i))
machine.poke(0, 2)

cmds = <<~COMMANDS
A,B,A,C,B,C,A,C,B,C
L,8,R,10,L,10
R,10,L,8,L,8,L,10
L,4,L,6,L,8,L,8
COMMANDS

# L,8,R,10,L,10,R,10,L,8,L,8,L,10,L,8,R,10,L,10,L,4,L,6,L,8,L,8,R,10,L,8,L,8,L,10,L,4,L,6,L,8,L,8,L,8,R,10,L,10,L,4,L,6,L,8,L,8,R,10,L,8,L,8,L,10,L,4,L,6,L,8,L,8

print machine.run_until_blocked
machine.dump_output.each { |c| print c.chr }

cmds.each_char do |c|
	machine.queue_input(c)
end
print machine.run_until_blocked
puts machine.input.inspect
machine.dump_output.each { |c| print c.chr }
machine.queue_input('n')
machine.queue_input("\n")

print machine.run_until_blocked
machine.dump_output.each { |c| print c < 255 ? c.chr : c }
