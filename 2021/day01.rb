vals = File.read(File.basename(__FILE__, ".rb") + ".input")

vals = vals.chomp.split.map(&:to_i)

p vals.each_cons(2).count { |x0, x1| x1 > x0 }
p vals.each_cons(3).map(&:sum).each_cons(2).count { |a, b| b > a }

