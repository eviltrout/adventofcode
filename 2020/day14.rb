data = File.read(File.basename(__FILE__, ".rb") + ".input")

data2 = <<~DATA
mask = 000000000000000000000000000000X1001X
mem[42] = 100
mask = 00000000000000000000000000000000X0XX
mem[26] = 1
DATA


mask = mask0 = mask1 = nil
mem = {}
mem2 = {}
xs = 0
data.split("\n").each do |l|
  if l =~ /mask = ([X01]+)/
    mask = $1
    xs = mask.count('X')
    mask0 = mask.gsub('X', '1').to_i(2)
    mask1 = mask.gsub('X', '0').to_i(2)
  elsif l =~ /mem\[(\d+)\] = (\d+)/
    address, val = $1.to_i, $2.to_i
    mem[address] = val & mask0 | mask1

    address = address.to_s(2).rjust(36, '0')
    (2 ** xs).times do |c|
      vals = c.to_s(2).rjust(xs, '0').split('').reverse
      mem2[mask.chars.map.with_index { |c, i| c == 'X' ? vals.pop : (c == '0' ? address[i] : 1) }.join] = val
    end
  end
end

p mem.values.sum
p mem2.values.sum
