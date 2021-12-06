input = File.read(File.basename(__FILE__, ".rb") + ".input")

fish = input.split(",").map(&:to_i)
days = [0, 0, 0, 0, 0, 0, 0, 0, 0]
fish.each { |f| days[f] += 1 }

256.times do |day|
  expired = days.shift
  days.push(expired)
  days[6] += expired
  puts "day: #{day+1} => #{days.sum}" if day == 79 || day == 255
end

