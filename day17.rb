require './utils'

def active_neighbors(x, y, z, map)
  total = 0
  (x-1..x+1).each do |x_d|
    (y-1..y+1).each do |y_d|
      (z-1..z+1).each do |z_d|
        next if x == x_d && y == y_d && z == z_d

        # position_string = "#{x + x_d}-#{y + y_d}-#{z + y_d}"
        position_string = "#{x_d}:#{y_d}:#{z_d}"
        total += 1 if map[position_string] == '#'
      end
    end
  end
  total 
end

def check_for_change(x, y, z, map, new_map)
  (x-1..x+1).each do |x_d|
    (y-1..y+1).each do |y_d|
      (z-1..z+1).each do |z_d|

        position_string = "#{x_d}:#{y_d}:#{z_d}"
        total_active_neighbors = active_neighbors(x_d, y_d, z_d, map)
        if map[position_string] == '#' && !((2..3).include? total_active_neighbors)
          new_map[position_string] = '.'
        elsif total_active_neighbors == 3
          new_map[position_string] = '#'
        end
      end
    end
  end
end

def cycle1(map)
  next_map = map.clone
  map.each do |k, v|
    x, y, z = k.split(":").map(&:to_i)
    check_for_change(x, y, z, map, next_map)
  end
  next_map
end

def part1
  map = {}
  lines = Utils.input_read(17)
  lines.each_with_index do |row, y|
    columns = row.chomp.split('')
    columns.each_with_index do |column, x|
      map["#{x}:#{y}:0"] = column
    end
  end
  6.times do
    map = cycle1(map)
  end
  puts map.count { |k, v| v == '#'}
end

part1


def active_neighbors_w(x, y, z, w, map)
  total = 0
  (x-1..x+1).each do |x_d|
    (y-1..y+1).each do |y_d|
      (z-1..z+1).each do |z_d|
        (w-1..w+1).each do |w_d|
          next if x == x_d && y == y_d && z == z_d && w == w_d
          # position_string = "#{x + x_d}-#{y + y_d}-#{z + y_d}"
          position_string = "#{x_d}:#{y_d}:#{z_d}:#{w_d}"
          total += 1 if map[position_string] == '#'
        end
      end
    end
  end
  total
end

def check_for_change_w(x, y, z, w, map, new_map, checked)
  (x-1..x+1).each do |x_d|
    (y-1..y+1).each do |y_d|
      (z-1..z+1).each do |z_d|
        (w-1..w+1).each do |w_d|
          position_string = "#{x_d}:#{y_d}:#{z_d}:#{w_d}"
          next if checked[position_string]

          total_active_neighbors = active_neighbors_w(x_d, y_d, z_d, w_d, map)
          if map[position_string] == '#' && !((2..3).include? total_active_neighbors)
            new_map[position_string] = '.'
          elsif total_active_neighbors == 3
            new_map[position_string] = '#'
          end

          checked[position_string] = true
        end
      end
    end
  end
end

def cycle1_w(map)
  next_map = map.clone
  checked = {}
  map.each do |k, v|
    x, y, z, w= k.split(":").map(&:to_i)
    check_for_change_w(x, y, z, w, map, next_map, checked)
  end
  next_map.select { |k, v| v == '#' }
end

def part2
  map = {}
  lines = Utils.input_read(17)
  lines.each_with_index do |row, y|
    columns = row.chomp.split('')
    columns.each_with_index do |column, x|
      map["#{x}:#{y}:0:0"] = column
    end
  end
  6.times do
    map = cycle1_w(map)
  end
  puts map.count { |k, v| v == '#'}
end

part2