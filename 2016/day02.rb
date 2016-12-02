
input = "ULL
RRDDD
LURDL
UUUUD"

input = File.read('day02.input')

pos = [1, 1]

input.split("\n").each do |row|
  row.split('').each do |dir|
    case dir
    when 'U' then pos[1] -= 1 if pos[1] > 0
    when 'D' then pos[1] += 1 if pos[1] < 2
    when 'L' then pos[0] -= 1 if pos[0] > 0
    when 'R' then pos[0] += 1 if pos[0] < 2
    end
  end

  print (pos[1] * 3) + pos[0] + 1
end
puts

grid = [
  %w(0 0 1 0 0),
  %w(0 2 3 4 0),
  %w(5 6 7 8 9),
  %w(0 A B C 0),
  %w(0 0 D 0 0)
]

pos = [0, 2]
input.split("\n").each do |row|
  row.split('').each do |dir|
    case dir
    when 'U' then pos[1] -= 1 if pos[1] > 0 && grid[pos[1]-1][pos[0]] != '0'
    when 'D' then pos[1] += 1 if pos[1] < 4 && grid[pos[1]+1][pos[0]] != '0'
    when 'L' then pos[0] -= 1 if pos[0] > 0 && grid[pos[1]][pos[0]-1] != '0'
    when 'R' then pos[0] += 1 if pos[0] < 4 && grid[pos[1]][pos[0]+1] != '0'
    end
  end

  print grid[pos[1]][pos[0]]
end
puts

