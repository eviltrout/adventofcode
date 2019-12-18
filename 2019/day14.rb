require 'set'

input = File.read('day14.input')

reactions = { }
reqs = input.split("\n").each do |l|
  input, output = l.split(" => ")
  qty, id = output.split(' ')
  reaction = { id: id, qty: qty.to_i }
  needs = []
  input.split(', ').each do |i|
    qty, id = i.split(' ')
    needs << { id: id, qty: qty.to_i }
  end
  reaction[:needs] = needs
  reactions[reaction[:id]] = reaction
end

reaction = reactions['FUEL']
wallet = Hash.new { 0 }

def create(reactions, qty, id, wallet)
  while wallet[id] < qty
    if r = reactions[id]
      r[:needs].each do |n|
        create(reactions, n[:qty], n[:id], wallet) while wallet[n[:id]] < n[:qty]
        wallet[n[:id]] -= n[:qty]
      end
      wallet[id] += r[:qty]
    else
      wallet['TOTAL_ORE'] += qty
      wallet[id] = qty
    end
  end
end

create(reactions, 1, 'FUEL', wallet)
puts wallet.delete('TOTAL_ORE')

wallet = Hash.new { 0 }
create(reactions, 20000, 'FUEL', wallet)
puts wallet.inspect

ratio = (1000000000000 / wallet['TOTAL_ORE'].to_f).floor
wallet['ORE'] = wallet['TOTAL_ORE']
wallet.each { |k, v| wallet[k] = wallet[k] * ratio }
wallet['ORE'] = 1000000000000 - wallet['ORE']

def make(id, qty, reactions, wallet)
  return false if id == 'ORE'
  r = reactions[id]
  count = 0
  while count < qty
    r[:needs].each do |need|
      needed = need[:qty] - wallet[need[:id]]
      enough = wallet[need[:id]] >= need[:qty]
      if needed > 0
        made = make(need[:id], needed, reactions, wallet)
        return false unless made
      end
      wallet[need[:id]] -= need[:qty]
    end
    count += r[:qty]
    wallet[id] += r[:qty]
  end
  true
end

can_make = true
while can_make
  can_make = make('FUEL', 1, reactions, wallet)
end
puts wallet.inspect
