require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

def process(pairs, counts, instructions)
  new_pairs = Hash.new { 0 }
  pairs.each do |k, v|
    counts[instructions[k]] += v
    new_pairs["#{k[0]}#{instructions[k]}"] += v
    new_pairs["#{instructions[k]}#{k[1]}"] += v
  end
  new_pairs.delete_if { |k, v| v == 0 }
end

lines = input.split("\n")
instructions = {}
lines[2..-1].map { |i| instructions[i[0..1]] = i[-1] }

poly = lines[0].chars
pairs = Hash.new { 0 } 
(0..poly.size-2).each { |i| pairs[(poly[i] + poly[i+1])] += 1 }
counts = poly.tally

10.times { pairs = process(pairs, counts, instructions) }
p counts.values.sort[-1] - counts.values.sort[0]
30.times { pairs = process(pairs, counts, instructions) }
p counts.values.sort[-1] - counts.values.sort[0]

