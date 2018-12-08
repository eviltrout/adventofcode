input = File.read("day08.input")

data = input.split.map(&:to_i)

def parse_node(data, i)
  node_count, meta_count = data[i], data[i + 1]
  node = { total: 0, value: 0 }

  j = i + 2
  node[:children] = []
  node_count.times do
    child = parse_node(data, j)
    node[:children] << child
    node[:total] += child[:total]
    j = child[:end]
  end

  meta_data = data[j...j + meta_count]
  node[:total] += meta_data.sum

  node[:value] +=
    (node_count == 0) ?
      node[:total] :
      meta_data.map { |md| node[:children][md - 1] }.compact.map { |x| x[:value] }.sum

  node[:end] = j + meta_count
  node
end

result = parse_node(data, 0)

puts result[:total]
puts result[:value]
