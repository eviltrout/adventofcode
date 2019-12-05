r = (136818..685979)

# r = [112233, 123444, 111122, 223333]
count = 0
r.each do |x|
  prev = 10
  found_same = false
  same_count = 0
  if x.digits.all? do |y|
    if y == prev
      same_count += 1
    else
      found_same = true if same_count == 1
      same_count = 0
    end

    result = y <= prev
    prev = y
    result
  end
    found_same = true if same_count == 1

    if found_same
      count += 1
    end
  end
end

puts count
