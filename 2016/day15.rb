require 'digest/md5'

# @salt = 'zpqevtbw'
@salt = 'abc'

IN_A_ROW = /.{3}/

@cached = {}

def hash_it(i)
  cached = @cached[i]
  return cached if cached

  result = "#{@salt}#{i}"
  2017.times do
    result = Digest::MD5.hexdigest(result)
  end
  @cached[i] = result
  result
end

def x_in_a_row?(x, i)
  md5 = hash_it(i)
  if m = (md5 =~ /([0-9a-f])\1\1/)
    return md5[m]
  end
  nil
end

def check_k(c, i)
  str = c*5
  (i+1...i+1001).each do |j|
    md5 = hash_it(j)
    return true if md5[str]
  end
  false
end

# three_in_a_row?(Digest::MD5.hexdigest("#{salt}18"))

keys_found = 0
300000.times do |i|
  if c = x_in_a_row?(3, i)
    if check_k(c, i)
      keys_found += 1
      puts "#{keys_found} -> #{i}"
    end
    if keys_found == 64
      puts i
      exit
    end
  end
end

