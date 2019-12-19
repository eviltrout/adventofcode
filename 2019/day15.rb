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

class Mapper
  DIR_X = { 1 => 0, 2 => 0, 3 => -1, 4 => 1 }
  DIR_Y = { 1 => -1, 2 => 1, 3 => 0, 4 => 0 }
  BACKWARDS = { 1 => 2, 2 => 1, 3 => 4, 4 => 3 }

  def initialize
    @map = {}
    @x = @y = 0
    @border = [0, 0, 0, 0]
    @oxygen = Set.new
    @map[key(0,0)] = 0
    @machine = Machine.new(File.read('day15.input').split(',').map(&:to_i))
  end

  def key(x, y)
    "#{x},#{y}"
  end

  def explore(steps = 0)
    move(1, steps)
    move(2, steps)
    move(3, steps)
    move(4, steps)
  end

  def move(dir, steps)
    cx, cy = @x, @y
    nx, ny = @x + DIR_X[dir], @y + DIR_Y[dir]

    @border[0] = nx if nx < @border[0]
    @border[1] = nx if nx > @border[1]
    @border[2] = ny if ny < @border[2]
    @border[3] = ny if ny > @border[3]
    k = key(nx, ny)

    if !@map[k].nil?
      @map[k] = steps if @map[k] > steps
      return
    end

    @machine.queue_input(dir)
    result = @machine.run_until_output
    if result == 0
      @map[k] = -1
    else
      @oxygen << k if result == 2
      @map[k] = steps
      @x, @y = nx, ny
      explore(steps + 1)
      @machine.queue_input(BACKWARDS[dir])
      result = @machine.run_until_output
      @x, @y = cx, cy
    end
  end

  def steps_to_oxygen
    @map[@oxygen.first] + 1
  end

  def output
    (@border[2]..@border[3]).each do |y|
      (@border[0]..@border[1]).each do |x|
        k = key(x, y)
        val = @map[k]
        if val == -1 || val.nil?
          print '#'
        elsif @oxygen.include?(k)
          print "O"
        else
          print '.'
        end
      end
      print "\n"
    end
  end

  def plot_oxygen(x, y)
    k = key(x, y)
    if @map[k] != -1 && !@oxygen.include?(k)
      @oxygen << k
      return true
    end
    false
  end

  def spread_oxygen
    @mins = 0
    plotted = true
    while plotted
      plotted = false
      @oxygen.to_a.each do |o|
        x, y = o.split(',').map(&:to_i)
        plotted |= plot_oxygen(x, y - 1)
        plotted |= plot_oxygen(x, y + 1)
        plotted |= plot_oxygen(x - 1, y)
        plotted |= plot_oxygen(x + 1, y)
      end
      @mins += 1 if plotted
    end
    @mins
  end

end

mapper = Mapper.new
mapper.explore
mapper.output
p mapper.spread_oxygen
mapper.output
