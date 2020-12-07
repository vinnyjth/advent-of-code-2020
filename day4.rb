require './utils'

def solve1
  lines = Utils.input_read(4)
  passports = lines.join("").split("\n\n")
  valid = passports.filter do |passport|
    fields = passport.split(/[ \n]/).map { |field| { key: field.split(':')[0], value: field.split(':')[1] } }
    ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'].all? do |f|
      fields.map {|ff| ff[:key] }.include? f
    end
  end.length

  # puts valid
end

solve1

def validate_date(date, min, max)
  date.length === 4 and date.to_i >= min and  date.to_i <= max
end

def validate_height(height)
  h = height.split(/(cm)|(in)/)
  return false if h.length != 2

  if h[1] == 'cm'
    return (h[0].to_i >= 150 and h[0].to_i <= 193)
  else
    return (h[0].to_i >= 59 and h[0].to_i <= 76)
  end
end

def solve2
  lines = Utils.input_read(4)
  passports = lines.join("").split("\n\n")
  valid = passports.filter do |passport|
    fields = {}
    passport.split(/[ \n]/).each { |field| fields[field.split(':')[0]] = field.split(':')[1] }

    puts 'all fields'
    next false unless ['byr', 'iyr', 'eyr', 'hgt', 'hcl', 'ecl', 'pid'].all? do |f|
      fields.keys.include? f
    end

    puts 'dates'
    next false unless validate_date(fields['byr'], 1920, 2002)
    next false unless validate_date(fields['iyr'], 2010, 2020)
    next false unless validate_date(fields['eyr'], 2020, 2030)

    puts 'height'
    next false unless validate_height(fields['hgt'])

    puts 'colors'
    next false unless fields['hcl'].match? /^#([a-f0-9]{6})$/
    next false unless %[amb blu brn gry grn hzl oth].include? fields['ecl']

    puts 'pid'
    next false unless fields['pid'].match? /^\d{9}$/

    puts 'end'

    true
  end.length

  puts valid
end


solve2