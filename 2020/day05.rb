data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
FBFBBFFRLR
BFFFBBFRRR
FFFBBBFRRR
BBFFBBFRLL
DATA

seat_ids = data.split.map do |b|
  row = [0, 127]
  col = [0, 7]
  b.each_char do |c|
    if c == 'F'
      row[1] = row[0] + ((row[1]-row[0])/2)
    elsif c == 'B'
      row[0] += ((row[1]-row[0])/2)+1
    elsif c == 'L'
      col[1] = col[0] + ((col[1]-col[0])/2)
    elsif c == 'R'
      col[0] += ((col[1]-col[0])/2)+1
    end
  end
  row[0] * 8 + col[0]
end.sort

puts seat_ids.max
puts seat_ids.find.with_index { |s, i| i > 0 && seat_ids[i-1] != (s - 1) } - 1
