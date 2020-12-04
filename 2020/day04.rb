data = File.read(File.basename(__FILE__, ".rb") + ".input")

data = <<~DATA
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
DATA

required = %w(byr iyr eyr hgt hcl ecl pid)

puts data.split("\n\n").count { |row|
  d = Hash[row.split.map { |r| r.split(":") }]
  required.all? { |r| d.has_key?(r) }
}

puts data.split("\n\n").count { |row|
  d = Hash[row.split.map { |r| r.split(":") }]

  required.all? { |r| d.has_key?(r) } &&
    (1920..2002).include?(d['byr'].to_i) &&
    (2010..2020).include?(d['iyr'].to_i) &&
    (2020..2030).include?(d['eyr'].to_i) &&
    ((d['hgt'].end_with?('cm') && (150..193).include?(d['hgt'].to_i)) || (d['hgt'].end_with?('in') && (59..76).include?(d['hgt'].to_i))) &&
    d['hcl'].match?(/^#[0-9a-f]{6}$/) &&
    %w(amb blu brn gry grn hzl oth).include?(d['ecl']) &&
    d['pid'].match?(/^[0-9]{9}$/)
}
