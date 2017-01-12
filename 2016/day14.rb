require 'digest/md5'

@salt = 'zpqevtbw'
# @salt = 'abc'

HASHES = 2017

@cached = {}

def hash_it(i)
  cached = @cached[i]
  return cached if cached

  result = "#{@salt}#{i}"
  HASHES.times { result = Digest::MD5.hexdigest(result) }
  @cached[i] = result
  result
end

def sequential?(i)
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

keys_found = 0
300000.times do |i|
  if c = sequential?(i)
    if check_k(c, i)
      keys_found += 1
      puts "#{keys_found} -> #{i}"
    end
    exit if keys_found == 64
  end
end

