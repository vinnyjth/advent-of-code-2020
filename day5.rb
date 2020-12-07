require './utils'

def split_in_half(chars, num_values, bottom_char)
  rows = (0..num_values).entries
  chars.each do |char|
    if char == bottom_char
      rows = rows[0...(rows.length / 2)]
    else
      rows = rows[(rows.length / 2)...rows.length]
    end
  end
  rows[0].to_i
end

def compute_seat_id(line)
  row = split_in_half(line.chars[0..6], 127, 'F')
  column = split_in_half(line.chars[7..-1], 7, 'L')
  seat_id = (row * 8) + column
  # puts seat_id
  seat_id
end

def solve1
  lines = Utils.input_read(5)
  max_line = lines.map do |line|
    compute_seat_id line
  end.max
  puts max_line
end

solve1

def solve2
  lines = Utils.input_read(5)
  seat_ids = lines.map do |line|
    compute_seat_id line
  end

  max_id = seat_ids.max

  my_seat = (0...max_id).entries.filter do |seat_id|
    seat_ids.include? seat_id - 1 and !seat_ids.include? seat_id and seat_ids.include? seat_id + 1
  end

  puts my_seat
end


solve2