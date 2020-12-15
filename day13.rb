require './utils'


def solve1
  input = Utils.input_read(13)
  target = input[0].to_i
  busses = input[1].split(',').reject { |c| c == 'x' }.map(&:to_i)
  nearest_buses = busses.map { |b| { buss: b, nearest_schedule: (target.to_f / b.to_f).ceil * b } }.sort_by { |b| b[:nearest_schedule]}
  pp (nearest_buses[0][:nearest_schedule] - target) * nearest_buses[0][:buss]
end

solve1

# brute force (good luck)
def solve2
  input = Utils.input_read(13)
  busses = input[1].split(',').each_with_index.map { |b, i| { buss: b.to_i, offset: i } }.filter { |b| b[:buss] != 0 }

  biggest_bus = busses.max { |b| b[:buss] }
  # puts biggest_bus
  sequence = Enumerator.new do |yielder|
    number = 0
    loop do
      number += biggest_bus[:buss]
      yielder.yield number
    end
  end

  t = sequence.find do |i|
    busses.all? { |b| (i + b[:offset] - biggest_bus[:offset]) % b[:buss] == 0 }
  end
  puts t
end

# solve2

def extended_gcd(a, b)
  last_remainder, remainder = a.abs, b.abs
  x, last_x, y, last_y = 0, 1, 1, 0
  while remainder != 0
    last_remainder, (quotient, remainder) = remainder, last_remainder.divmod(remainder)
    x, last_x = last_x - quotient*x, x
    y, last_y = last_y - quotient*y, y
  end
  return last_remainder, last_x * (a < 0 ? -1 : 1)
end

def invmod(e, et)
  g, x = extended_gcd(e, et)
  if g != 1
    raise 'Multiplicative inverse modulo does not exist!'
  end
  x % et
end

def chinese_remainder(mods, remainders)
  max = mods.inject( :* )  # product of all moduli
  series = remainders.zip(mods).map{ |r,m| (r * max * invmod(max/m, m) / m) }
  series.inject( :+ ) % max 
end

def solve2_v2
  input = Utils.input_read(13)
  busses = input[1].split(',').each_with_index.map { |b, i| { buss: b.to_i, offset: i } }.filter { |b| b[:buss] != 0 }

  busses.each do |b|
    puts [b[:buss], b[:buss] - (b[:offset] % b[:buss])].join(',')
  end

  puts "chinese_remainder"
  puts chinese_remainder(
    busses.map { |b| b[:buss] },
    busses.map { |b| b[:buss] - (b[:offset] % b[:buss]) }
  )
end


solve2_v2