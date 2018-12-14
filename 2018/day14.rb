target = "077201"

scores = "37"
elf1 = 0
elf2 = 1

20_000_000.times do
  s1 = scores[elf1].to_i
  s2 = scores[elf2].to_i

  total = s1 + s2
  scores << total.to_s
  elf1 = (elf1 + 1 + s1) % scores.size
  elf2 = (elf2 + 1 + s2) % scores.size
end
puts scores[target.to_i..target.to_i + 9]
puts scores.index(target)
