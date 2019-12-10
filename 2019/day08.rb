w = 25
h = 6
input = File.read("day08.input").chomp

layer_size = w * h
layers = input.size / layer_size
offset = input.size - layer_size

layer = 1
layer_row = 0
counts = Hash.new { 0 }
result = [1000, nil, nil]
image = []

while offset >= 0
	image[layer_row] ||= (0...w).map { "0" }

	chunk = input[offset...offset+w]
	chunk.chars.each_with_index do |d, i|
		v = d.to_i
		image[layer_row][i] = v unless v == 2
		counts[v] += 1
	end

	offset += w
	layer_row += 1
	if layer_row == h
		offset -= (layer_size * 2)
		if counts[0] < result[0]
			result[0] = counts[0]
			result[1] = layer
			result[2] = counts[1] * counts[2]
		end

		counts = Hash.new { 0 }
		layer_row = 0
		layer += 1
	end
end
puts result[2]
image.each { |row| puts row.join }
