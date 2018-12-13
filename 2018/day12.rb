input = File.read("day12.input")
state = 0

translations = []

input.gsub("#", "1").gsub(".", "0").each_line do |l|
  if l =~ /initial state: ([01]+)$/
    state = Regexp.last_match[1].to_i(2)
  elsif l =~ /([01]+) => ([1])/
    translations << Regexp.last_match[1].to_i(2)
  end
end

padding = 400
state = state << padding

mask_size = 5
bin_length = state.to_s(2).size + padding
orig_size = state.to_s(2).split('').map(&:to_i).size

350.times do |gen|
  mask = 31 << (bin_length - mask_size)
  new_state = 0
  (bin_length - 4).times do |x|
    val = (state & mask) >> (bin_length - x - mask_size)

    translations.each do |t|
      if val == t
        new_state = (1 << (bin_length - x - mask_size + 2)) | new_state
        break
      end
    end

    mask = mask >> 1
  end
  state = new_state
end

vals = state.to_s(2).split('').map(&:to_i)
p vals.map.with_index { |v, i| v == 1 ? (i - (vals.size - orig_size)) : 0 }.sum
