data = File.read(File.basename(__FILE__, ".rb") + ".input")

class Compiler
  def initialize(input, hack = false)
    @rules = {}
    @hack = hack
    input.split(?\n).each do |r|
      id, code = r.split(": ")
      @rules[id.to_i] = code
    end
  end

  def compile_expr(expr)
    return "a" if expr['"a"']
    return "b" if expr['"b"']
    expr.split(" ").map { |r| compile_id(r.to_i) }.join
  end

  def compile_id(id)
    if @hack
      return compile_id(42) + "+" if id == 8

      if id == 11
        ls = compile_id(42)
        rs = compile_id(31)
        return "#{ls}(#{ls}(#{ls}(#{ls}(#{ls}#{rs})?#{rs})?#{rs})?#{rs})?#{rs}"
      end
    end

    rule = @rules[id]

    if rule.index(?|)
      ls, rs = rule.split(" | ")
      ls = compile_expr(ls)
      rs = compile_expr(rs)
      return "(#{ls}|#{rs})"
    end
    compile_expr(rule)
  end

  def compile
    Regexp.new("^#{compile_id(0)}$")
  end
end

rules_in, inputs = data.split("\n\n")

reg = Compiler.new(rules_in).compile
p inputs.split("\n").count { |i| reg.match?(i) }

reg = Compiler.new(rules_in, true).compile
p inputs.split("\n").count { |i| reg.match?(i) }
