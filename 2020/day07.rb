data = File.read(File.basename(__FILE__, ".rb") + ".input")

test_data = <<~DATA
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
DATA

nodes = {}

data.split("\n").each do |row|
  if m = row.match(/^([a-z]+ [a-z]+) bags contain /)
    id = m[1]

    node = { id: id, children: [] }
    row.sub(m[0], "").split(/, /).each do |b|
      if m1 = b.match(/^(\d+) ([a-z]+ [a-z]+)/)
        node[:children] << { qty: m1[1].to_i, id: m1[2] }
      end
    end
    nodes[id] = node
  end
end

def contains?(nodes, node, id)
  node[:children].any? { |c| c[:id] == id || contains?(nodes, nodes[c[:id]], id) }
end

def count_bags(nodes, id)
  node = nodes[id]
  1 + node[:children].sum { |n| n[:qty] * count_bags(nodes, n[:id]) }
end

puts nodes.values.count { |n| contains?(nodes, n, 'shiny gold') }
puts count_bags(nodes, 'shiny gold') - 1
