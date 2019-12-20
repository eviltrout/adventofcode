input = File.read("day16.input").chars.map(&:to_i)

def phases(input, n)
  n.times do |ni|
    digits = []
    (0...input.size).each do |d|
      offset = d
      repeat = d + 1

      sum = 0
      flip = 1
      while offset < input.size
        ubound = offset + repeat
        ubound = input.size if ubound > input.size
        sum += input[offset...ubound].sum { |x| x * flip }
        offset = ubound + repeat
        flip *= -1
      end
      digits << (sum.abs % 10)
    end
    input = digits
  end
  p input[0...8]
end

phases(input, 100)

input = File.read("day16.input").strip * 10000
offset = input[0...7].to_i

input = input[offset..-1].chars.map(&:to_i)
puts input.size

100.times do
  (input.size - 2).downto(0) do |i|
    input[i] = (input[i] + input[i + 1]) % 10
  end
end
puts input[0...8].join

