input = File.read("day07.input")

def abba(str)
  str.chars.each_cons(4).any? {|a, b, c, d| a != b && b == c && d == a}
end

def ssl(grouped)
  grouped[:even].any? do |r|
    r.chars.each_cons(3) do |a, b, c|
      return true if a != b && a == c && grouped[:odd].any? {|h| h[b + a + b]}
    end
  end
end

count = 0
ssl_count = 0
input.split("\n").each do |ip|
  grouped = ip.split(/[\[\]]/).group_by.with_index {|_, i| i.odd? ? :odd : :even }
  count += 1 if !grouped[:odd].any? {|s| abba(s) } && grouped[:even].any? {|s| abba(s) }
  ssl_count += 1 if ssl(grouped)
end
puts "count: #{count}"
puts "ssl_count: #{ssl_count}"

