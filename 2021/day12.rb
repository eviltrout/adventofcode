require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

nodes = {}
input.split("\n").each do |l|
  from, to = l.split("-")
  nodes[from] ||= []
  nodes[to] ||= []
  nodes[from] << to
  nodes[to] << from
end

def find_paths(nodes, node, visited, has_dupe, all_paths)
  if node[0] == node[0].downcase && visited.include?(node)
    return all_paths if has_dupe
    has_dupe = true
  end
  return all_paths if node == "start" && visited.include?("start")

  visited << node
  if node == "end"
    all_paths << visited
    return all_paths
  end

  nodes[node].each { |p| find_paths(nodes, p, visited.dup, has_dupe, all_paths) }
  all_paths
end

puts find_paths(nodes, "start", [], true, []).size
puts find_paths(nodes, "start", [], false, []).size
