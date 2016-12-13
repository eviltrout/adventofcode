input = "value 5 goes to bot 2\nbot 2 gives low to bot 1 and high to bot 0\nvalue 3 goes to bot 1\nbot 1 gives low to output 1 and high to bot 0\nbot 0 gives low to output 2 and high to output 0\nvalue 2 goes to bot 2"
input = File.read("day10.input")

class Resolver

  attr_reader :output

  def initialize
    @bots = {}
    @observers = {}
    @output = {}
  end

  def find_bot(bot_id)
    @bots[bot_id] ||= { vals: [] }
    @bots[bot_id]
  end

  def give(bot_id, val)
    bot = find_bot(bot_id)
    bot[:vals] << val

    if bot[:vals].size == 2
      handle_observer(bot_id)
    end
  end

  def handle_observer(bot_id)
    if ob = @observers[bot_id]
      bot = find_bot(bot_id)
      if bot[:vals].size == 2
        low = bot[:vals].min
        high = bot[:vals].max

        puts "bot: #{bot_id}" if low == 17 && high == 61
        bot[:vals].clear

        ob[:low_dest] == :bot ? give(ob[:low_id], low) : @output[ob[:low_id]] = low
        ob[:high_dest] == :bot ? give(ob[:high_id], high) : @output[ob[:high_id]] = high
      end
    end
  end

  def parse(input)
    input.split("\n").each do |l|
      if l =~ /value (\d+) goes to bot (\d+)/
        give($2.to_i, $1.to_i)
      elsif l =~ /bot (\d+) gives low to ([a-z]+) (\d+) and high to ([a-z]+) (\d+)/
        @observers[$1.to_i] = {low_dest: $2.to_sym, low_id: $3.to_i, high_dest: $4.to_sym, high_id: $5.to_i}
        handle_observer($1.to_i)
      end
    end
  end
end

resolver = Resolver.new
resolver.parse(input)
outputs = resolver.output

puts outputs[0] * outputs[1] * outputs[2]
