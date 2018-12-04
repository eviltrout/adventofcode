require 'time'

data = File.read("day04.input")

# Sort the dates
commands = []
data.each_line do |l|
  m = l.match(/\[(?<date>[^\]]+)\] (?<command>.*)/)
  commands << [Time.parse(m[:date]), m[:command]]
end
commands.sort_by! { |e| e[0] }

start = nil
guard = nil
by_guard = {}

# Parse commands
commands.each do |e|
  dt, command = e

  if command =~ /Guard #(?<guard>\d+) begins shift/
    id = Regexp.last_match[:guard].to_i
    guard = by_guard[id] || { id: id, total: 0, naps: [] }
    by_guard[id] = guard
  elsif command =~ /falls asleep/
    start = dt
  elsif command =~ /wakes up/
    nap = (start.min...dt.min)
    guard[:naps] << nap
    guard[:total] += nap.size
  end
end

all_guards = by_guard.values

# Part One
guard = all_guards.max_by { |g| g[:total] }
most_sleep_at = (0..59).max_by { |m| guard[:naps].count { |n| n.include?(m) } }
puts "guard: #{guard[:id]}"
puts "most_sleep_at: #{most_sleep_at}"
puts "value: #{guard[:id] * most_sleep_at}"

# Part Two
max_count = 0
max_min = 0
guard = nil
(00..59).each do |m|
  all_guards.each do |g|
    count = g[:naps].count { |n| n.include?(m) }
    if count > max_count
      max_count = count
      max_min = m
      guard = g
    end
  end
end
puts "guard: #{guard[:id]}"
puts "max sleep min: #{max_min}"
puts "value: #{max_min * guard[:id]}"
