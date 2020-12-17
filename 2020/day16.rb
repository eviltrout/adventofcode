data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
class: 1-3 or 5-7
row: 6-11 or 33-44
seat: 13-40 or 45-50

your ticket:
7,1,14

nearby tickets:
7,3,47
40,4,50
55,2,20
38,6,12
DATA

data = data.split("\n\n")

def range_for(s)
  Range.new(*s.split(?-).map(&:to_i))
end

fields = {}
data[0].split("\n").map do |c|
  segs = c.split(?:)
  ranges = segs[1].split(" ")
  fields[segs[0]] = [range_for(ranges[0]), range_for(ranges[2])]
end
all_ranges = fields.values.flatten

valid = []
puts data[2].split("\n")[1..-1].inject(0) { |invalid, near|
  row = near.split(?,).map(&:to_i)

  old_invalid = invalid
  row.each { |v| invalid += v unless all_ranges.any? { |r| r.include?(v) } }
  valid << row if old_invalid == invalid
  invalid
}

field_ids = fields.keys
possibles = {}
field_ids.size.times do |c|
  possible = field_ids.dup
  field_ids.each { |id| possible.delete(id) if valid.any? { |r| !fields[id][0].include?(r[c]) && !fields[id][1].include?(r[c]) } }
  possibles[c] = possible
end

answers = []
possibles.keys.size.times do |it|
  counts = {}
  last_seen = {}
  field_ids.each do |id|
    possibles.each do |i, p|
      if p.include?(id)
        last_seen[id] = i
        counts[id] = (counts[id] || 0) + 1
      end
    end
  end

  counts.each do |id, c|
    if c == 1
      answers[last_seen[id]] = id
      possibles.delete(last_seen[id])
      break
    end
  end
end

mine = data[1].split("\n")[1].split(?,).map(&:to_i)
p answers.map.with_index { |a, i| (a || "").start_with?("departure") ? mine[i] : 1 }.inject(:*)

