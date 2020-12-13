require './utils'


def should_be_empty?(map, x, y)
  return false if map[y][x] != '#'
  total = 0
  (-1..1).each do |x_mod|
    (-1..1).each do |y_mod|
      next if y_mod == 0 && x_mod == 0
      next if out_of_range?(map, x + x_mod, y + y_mod)
      total += 1 if map[y + y_mod][x + x_mod] == '#'
    end
  end
  total >= 4
end

def out_of_range?(map, x, y)
  y < 0 ||
  x < 0 ||
  y >= map.length ||
  x >= map[y].length
end


def should_be_occupied?(map, x, y)
  return false if map[y][x] != 'L'
  has_neighbors = (-1..1).any? do |x_mod|
    (-1..1).any? do |y_mod|
      next if y_mod == 0 && x_mod == 0
      next if out_of_range?(map, x + x_mod, y + y_mod)
      map[y + y_mod][x + x_mod] == '#'
    end
  end
  !has_neighbors
end


def far_should_be_occupied?(map, x, y)
  return false if map[y][x] != 'L'
  has_neighbors = (-1..1).any? do |x_mod|
    (-1..1).any? do |y_mod|
      next if y_mod == 0 && x_mod == 0
      current_search = '.'
      i = 1
      while current_search == '.'
        break if out_of_range?(map, x + (x_mod * i), y + (y_mod * i))
        current_search = map[y + (y_mod * i)][x + (x_mod * i)]
        i += 1
      end
      current_search == '#'
    end
  end
  !has_neighbors
end

def far_should_be_empty?(map, x, y)
  return false if map[y][x] != '#'
  total = 0
  (-1..1).each do |x_mod|
    (-1..1).each do |y_mod|
      next if y_mod == 0 && x_mod == 0
      next if out_of_range?(map, x + x_mod, y + y_mod)
      current_search = '.'
      i = 1
      while current_search == '.'
        break if out_of_range?(map, x + (x_mod * i), y + (y_mod * i))
        current_search = map[y + (y_mod * i)][x + (x_mod * i)]
        i += 1
      end
      total += 1 if current_search == '#'
    end
  end
  total >= 5
end

def new_seat_state(map, x, y)
  return 'L' if should_be_empty?(map, x, y)
  return '#' if should_be_occupied?(map, x, y)
  return map[y][x]
end

def far_new_seat_state(map, x, y)
  return 'L' if far_should_be_empty?(map, x, y)
  return '#' if far_should_be_occupied?(map, x, y)
  return map[y][x]
end

def gen_next_stage(map)
  map.each_with_index.map { |row, y| row.split('').each_with_index.map { |_, x| new_seat_state(map, x, y) }.join('') }
end

def far_gen_next_stage(map)
  map.each_with_index.map { |row, y| row.split('').each_with_index.map { |_, x| far_new_seat_state(map, x, y) }.join('') }
end

def maps_equal(old_map, new_map)
  old_map.join('') == new_map.join('')
end

def solve1
  map = Utils.input_read(11).map(&:chomp)
  changes = true
  while changes do
    new_map = gen_next_stage(map)
    changes = !maps_equal(map, new_map)
    map = new_map
  end
  puts map.join('').split('').filter { |c| c == '#' }.length
end

solve1

def solve2
  map = Utils.input_read(11).map(&:chomp)
  changes = true
  while changes do
    new_map = far_gen_next_stage(map)
    changes = !maps_equal(map, new_map)
    map = new_map
  end
  puts map.join('').split('').filter { |c| c == '#' }.length
end


solve2