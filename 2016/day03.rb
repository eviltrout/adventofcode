input = File.read('day03.input')

tris = []
cols = [[], [], []]

def possible(tri)
  (tri[0] + tri[1] > tri[2]) && (tri[1] + tri[2] > tri[0]) && (tri[2] + tri[0] > tri[1])
end

count = 0
input.split("\n").each_with_index do |line, i|
  tri = line.split.map(&:to_i)

  if i > 0 && i % 3 == 0
    (0..2).each {|j| tris << cols[j] }
    cols = [[], [], []]
  end

  (0..2).each {|j| cols[j] << tri[j] }

  count += 1 if possible(tri)
end
puts count

(0..2).each {|j| tris << cols[j] }
puts tris.inject(0) {|c, tri| possible(tri) ? c + 1 : c }
