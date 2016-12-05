require 'digest/md5'

input = "cxdnnyjw"

# part 1
idx = 0
password = []
while password.size < 8
  idx += 1
  password << hashed[5] if hashed[0..4] == "00000"
  print "." if (idx % 100000) == 0
end
puts
puts password.join

# part 2
idx = 0
password = []
while password.join.size < 8
  idx += 1
  hashed = Digest::MD5.hexdigest("#{input}#{idx}")
  if hashed[0..4] == "00000"
    pos = hashed[5].to_i(16)
    password[pos] = hashed[6] if pos < 8 && !password[pos]
  end
  print "." if (idx % 100000) == 0
end
puts
puts password.join


