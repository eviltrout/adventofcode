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
      # @prog[@prog[@i + 3]] = cmd == 1 ? params[0] + params[1] : params[0] * params[1]
      @i += 4
    when 3
      return if @input.empty?
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

  def run_until_output
    advance while running? && @output.empty?
    @output.pop
  end

  def run_until_finished
    advance while running?
    @output
  end

  def running?
    @state == :running
  end

  def ended?
    @state == :ended
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

machine = Machine.new(File.read('day11.input').split(',').map(&:to_i))
tiles = {}
tiles["0,0"] = 1
robot = [0, 0]
dir = 0

while machine.running?
  pos = "#{robot[0]},#{robot[1]}"
  machine.queue_input(tiles[pos] || 0)
  color = machine.run_until_output
  inst = machine.run_until_output
  tiles[pos] = color

  dir = (dir + ((inst == 0) ? -1 : 1)) % 4
  case dir
  when 0
    robot[1] -= 1
  when 1
    robot[0] += 1
  when 2
    robot[1] += 1
  when 3
    robot[0] -= 1
  end
end

6.times do |y|
  41.times do |x|
    print tiles["#{x},#{y}"] == 1 ? '#' : '.'
  end
  puts "\n"
end


