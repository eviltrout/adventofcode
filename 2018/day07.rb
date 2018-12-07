input = <<~DATA
Step C must be finished before step A can begin.
Step C must be finished before step F can begin.
Step A must be finished before step B can begin.
Step A must be finished before step D can begin.
Step B must be finished before step E can begin.
Step D must be finished before step E can begin.
Step F must be finished before step E can begin.
DATA

WORKER_COUNT = 5
EXTRA_TIME = 60
input = File.read("day07.input")

def build_graph(input)
  graph = {}
  input.each_line do |l|
    tokens = l.split
    before, after = tokens[1], tokens[7]

    graph[before] ||= []
    graph[after] ||= []
    graph[after] << before
  end
  graph
end

# Part One
graph = build_graph(input)
while !graph.empty?
  step = graph.select { |k, v| v.empty? }.keys.sort[0]
  print step
  graph.delete(step)
  graph.values.each { |v| v.delete(step) }
end
puts

# Part Two
workers = Array.new(WORKER_COUNT)
graph = build_graph(input)
by_job = {}

t = 0
while !graph.empty?
  # Remove old ones
  graph.select { |k, v| v.empty? }.keys.sort.each do |j|
    if current = by_job[j]
      if current[:count] <= 1
        graph.delete(j)
        graph.values.each { |v| v.delete(j) }
        by_job.delete(j)
      end
    end
  end

  graph.select { |k, v| v.empty? }.keys.sort.each do |j|
    if current = by_job[j]
      current[:count] -= 1
    elsif by_job.keys.size < WORKER_COUNT
      by_job[j] = { count: j.ord - 64 + EXTRA_TIME }
    end
  end
  t += 1
end

puts t - 1
