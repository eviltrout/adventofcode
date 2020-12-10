data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
16
10
15
5
1
11
7
19
6
12
4
DATA

data2 = <<~DATA
28
33
18
42
31
14
46
20
48
47
24
23
49
45
19
38
39
11
1
32
25
35
8
17
7
9
4
2
34
10
3
DATA

diffs = ([0] + data.split).map(&:to_i).sort.each_cons(2).map { |c| c[1] - c[0] } + [3]
puts diffs.count(3) * diffs.count(1)

count = 0
sum = 1
routes = [1, 1, 2, 4, 7]
diffs.each do |n|
  if n == 1
    count += 1
  else
    sum *= routes[count]
    count = 0
  end
end
puts sum
