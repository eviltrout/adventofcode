input = File.read('day03.input')

cols = [[], [], []]

def possible(tri)
  (tri[0] + tri[1] > tri[2]) && (tri[1] + tri[2] > tri[0]) && (tri[2] + tri[0] > tri[1])
end

count = 0
v_count = 0
input.split("\n").each_with_index do |line, i|
  tri = line.split.map(&:to_i)

  if i > 0 && i % 3 == 0
    (0..2).each {|j| v_count +=1 if possible(cols[j]) }
    cols = [[], [], []]
  end

  (0..2).each {|j| cols[j] << tri[j] }

  count += 1 if possible(tri)
end
puts count

(0..2).each {|j| v_count +=1 if possible(cols[j]) }
puts v_count
