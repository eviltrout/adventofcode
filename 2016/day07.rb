input = File.read("day07.input")

def abba(str)
  return false if str.size < 4
  (1..str.size-2).each do |i|
    return true if (str[i-1] != str[i]) && (str[i-1] == str[i+2]) && (str[i] == str[i+1])
  end
  false
end

def ssl(grouped)
  grouped[:even].each do |r|
    (0..r.size-2).each do |i|
      if (r[i] != r[i+1]) && (r[i] == r[i+2])
        return true if grouped[:odd].any? {|h| h.include?("#{r[i+1]}#{r[i]}#{r[i+1]}")}
      end
    end
  end
  return false
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

