require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

data = input.chomp.chars.map { |c| c.hex.to_s(2).rjust(4, '0') }.join

def parse(data, offset)
  version = data[offset...offset+3].to_i(2)
  type = data[offset+3...offset+6].to_i(2)

  if type == 4
    idx = offset+6
    nums = ""
    while data[idx] == '1'
      nums << data[idx+1...idx+5]
      idx += 5
    end
    nums << data[idx+1...idx+5]
    num = nums.to_i(2)

    return [version, type, num, idx+5-offset]
  else
    length_type = data[offset+6]
    if data[offset+6] == "0"
      stop = data[offset+7...offset+22].to_i(2)

      contents = []
      i = 0
      start = offset+22
      while i < stop
        result = parse(data, start+i)
        contents << result
        i += result[3]
      end
      return [version, type, contents, i+22]
    else
      count = data[offset+7...offset+18].to_i(2)
      contents = []

      start = x = (offset+18)
      count.times do |i|
        result = parse(data, x)
        contents << result
        x += result[3]
      end
      return [version, type, contents, x-start+18]
    end
  end
end

def sum_versions(data)
  version, type, contents = data
  version += contents.sum { |x| sum_versions(x) } if type != 4
  version
end

def execute(data)
  version, type, contents = data
  return contents if type == 4

  vals = contents.map { |x| execute(x) }
  case type
  when 0
    vals.inject(:+)
  when 1
    vals.inject(:*)
  when 2
    vals.min
  when 3
    vals.max
  when 5
    vals[0] > vals[1] ? 1 : 0
  when 6
    vals[0] < vals[1] ? 1 : 0
  when 7
    vals[0] == vals[1] ? 1 : 0
  end
end

result = parse(data, 0)
p sum_versions(result)
puts execute(result)

