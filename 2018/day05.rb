data = "dabAcCaCBAcCcaDA"
data = File.read("day05.input").chomp

patterns = ('a'..'z').map { |l| "#{l}#{l.upcase}|#{l.upcase}#{l}" }
$regexp = Regexp.new(patterns.join("|"))

def collapse(input)
  result = input.gsub($regexp, '')
  Regexp.last_match ? collapse(result) : result.size
end

puts collapse(data)

result_for = {}
result = data.downcase.chars.uniq.min_by do |c|
  to_check = data.gsub(/#{c}|#{c.upcase}/, '')
  result_for[c] = collapse(to_check)
end
puts result
puts result_for[result]
