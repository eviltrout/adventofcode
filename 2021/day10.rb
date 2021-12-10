require 'set'

input = File.read(File.basename(__FILE__, ".rb") + ".input")

CHARS = { ?[ => ?], ?{ => ?}, ?( => ?), ?< => ?> }
SCORES = { ?) => 3, ?] => 57, ?} => 1197, ?> => 25137 }
AUTOSCORE = { ?) => 1, ?] => 2, ?} => 3, ?> => 4 }

def divein(line, start, depth = 0)
  i = start + 1
  while i < line.size
    if CHARS.has_key?(line[i])
      result, arg = divein(line, i, depth + 1)
      if result == :skip
        i = arg
      else 
        arg << line[start] if result == :incomplete && CHARS.has_key?(line[start])
        return [result, arg]
      end
    elsif CHARS[line[start]] == line[i]
      return (depth == 0 && i == line.size - 1) ? :success : [:skip, i]
    else
      return [:corrupt, line[i]]
    end
    i += 1
  end
  [:incomplete, [line[start]]]
end

def valid(line)
  result = :skip
  idx = 0
  while result == :skip
    result, idx = divein(line, idx)
    if result == :skip && idx == line.size
      return :success
    end
  end
  [result, idx]
end

sums = []
autocompleted = []
input.split("\n").each do |l|
  result, arg = valid(l)
  if result == :corrupt
    sums << SCORES[arg]
  elsif result == :incomplete
    autocompleted << arg.inject(0) { |m, i| (m * 5) + AUTOSCORE[CHARS[i]] }
  end
end

puts sums.sum
autocompleted.sort!
p autocompleted[autocompleted.size / 2]
