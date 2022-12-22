data = File.read("day21.input").split("\n")
monkeys = data.to_h { _1.split ?: }.transform_values { _1[/\d/] ? _1.to_i : _1.split }

def 🧮(monkeys)
  Hash.new { |h, k|
    v = monkeys[k]
    h[k] = Integer === v ? v : h[v[0]].send(v[1], h[v[2]])
  }
end

p 🧮(monkeys)["root"]

l, _, r = monkeys["root"]

p (0..).bsearch { 🧮(monkeys.merge("humn" => _1))[l] <=> 🧮(monkeys)[r] }

