input = "aaaaa-bbb-z-y-x-123[abxyz]\na-b-c-d-e-f-g-h-987[abcde]\nnot-a-real-room-404[oarel]\ntotally-real-room-200[decoy]"
input = File.read("day04.input")

sum = 0
input.each_line do |l|
  _, letters, sector, checksum = l.match(/([a-z\-]*)\-(\d*)\[(.*)\]/).to_a
  sector = sector.to_i
  delta = sector % 26

  counts = Hash.new { 0 }
  letters.gsub('-', '').chars.each {|x| counts[x] = counts[x] + 1 }
  if counts.to_a.sort_by {|c| [-c[1], c[0]]}.map {|c| c[0] }.join[0..4] == checksum

    decoded = letters.codepoints.map do |c|
      c == 45 ? ' ' : ((c + delta >= 123) ? c + delta - 26 : c + delta).chr
    end.join

    puts "#{sector} -> #{decoded}" if decoded =~ /northpole/
    sum += sector
  end
end

puts sum
