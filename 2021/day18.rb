require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

class SnailNumber
  attr_reader :n, :parent, :idx
  def initialize(parent, idx)
    @n, @parent, @idx = parent[idx], parent, idx
  end

  def add(n)
    @parent[@idx] += n
  end
end

class Tree
  def initialize(vals)
    @vals = vals
		process
  end

  def add_number(parent, idx)
    @prev = SnailNumber.new(parent, idx)

    if @filter == :splits && @state == :none && parent[idx] >= 10
      @target = @prev
      @state = :split
      return :split
    end

    if @state == :exploding && !parent.equal?(@target)
      @target_r = @prev
      @state = :exploded
      return :exploded
    end
  end

  def finished?
    @state == :exploded || @state == :split
  end

  def parse_val(val, depth, parent)
    return if finished?

    if @state == :none && depth == 4
      @state = :exploding
      @target_l = @prev
      @target = val
      @target_parent = parent
    end

    val[0].is_a?(Array) ?  parse_val(val[0], depth + 1, val) : add_number(val, 0)
    return if finished?

    val[1].is_a?(Array) ?  parse_val(val[1], depth + 1, val) : add_number(val, 1)
  end

  def reset_state
    @state = :none
    @target = @target_l = @target_r = @target_parent = nil
    @prev = nil
  end

  def process
    reset_state
    @filter = :explodes
    parse_val(@vals, 0, nil)
    if @state == :exploded || @state == :exploding
      haystack = @vals.inspect.gsub(/\[|\]|\ |,/, "")
      @target_l&.add(@target[0])
      @target_r&.add(@target[1])
      @target_parent[(@target_parent[0] == @target) ? 0 : 1] = 0

      return process
    end

    reset_state
    @filter = :splits
    parse_val(@vals, 0, nil)
    if @state == :split
      half = @target.n / 2.0
      @target.parent[@target.idx] = [half.floor, half.ceil]
      return process
    end
  end

  def add(x)
    @vals = [@vals, x]
    process
  end

	def calc_magnitude(vals)
		if vals.is_a?(Array)
			return 3 * calc_magnitude(vals[0]) + 2 * calc_magnitude(vals[1])
		else
			return vals
		end
	end

	def magnitude
		calc_magnitude(@vals)
	end
end

lines = input.split("\n")
t = Tree.new(eval(lines[0]))
lines[1..-1].each { |l| t.add(eval(l)) }
puts t.magnitude

vals = []
lines.permutation(2).each { |c|
	t = Tree.new(eval(c[0]))
	t.add(eval(c[1]))
	vals << t.magnitude
}
p vals.max
