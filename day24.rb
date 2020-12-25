require './utils'


def new_color(tile_coords, tile_color, all_tiles)
  neighbors = [-1, 0, 1].permutation.map do |neighbor_coords|
    x_mod, y_mod, z_mod = neighbor_coords
    neighbor_key = [x_mod + tile_coords[:x], y_mod + tile_coords[:y], z_mod + tile_coords[:z]].join('|')
    if all_tiles[neighbor_key]
      all_tiles[neighbor_key]
    end
  end.compact
  black_neighbors = neighbors.count(:black)
  white_neighbors = neighbors.count(:white)

  if tile_color == :black && (black_neighbors > 2 || black_neighbors == 0)
    :white
  elsif tile_color == :white && black_neighbors == 2
    :black
  else
    tile_color
  end
end

def flip_neighbors(tile_coords, current_map, next_map)
  [-1, 0, 1].permutation.each do |neighbor_coords|
    x_mod, y_mod, z_mod = neighbor_coords
    neighbor_key = [x_mod + tile_coords[:x], y_mod + tile_coords[:y], z_mod + tile_coords[:z]].join('|')
    next if current_map[neighbor_key]
    next_map[neighbor_key] = new_color({
      x: x_mod + tile_coords[:x],
      y: y_mod + tile_coords[:y],
      z: z_mod + tile_coords[:z]
    }, :white, current_map)
  end
end

def find_tile_coords(directions)
  coords = { x: 0, y: 0, z: 0 }
  directions.each do |dir|
    case dir
    when "ne"
      coords[:x] += 1
      coords[:z] -= 1
    when "se"
      coords[:z] += 1
      coords[:y] -= 1
    when "nw"
      coords[:z] -= 1
      coords[:y] += 1
    when "sw"
      coords[:z] += 1
      coords[:x] -= 1
    when "w"
      coords[:x] -= 1
      coords[:y] += 1
    when "e"
      coords[:x] += 1
      coords[:y] -= 1
    end
  end
  coords
end

def solve1
  lines = Utils.input_read(24)
  directions = lines.map do |l|
    l.chomp.scan(/n[ew]{1}|s[we]{1}|e|w|/).select { |m| m != '' }
  end
  tiles = {}
  directions.each do |directions|
    final_coords = find_tile_coords(directions)
    key = final_coords.values.join('|')
    if tiles[key] && tiles[key] == :black
      tiles[key] = :white
    else
      tiles[key] = :black
    end
  end
  puts tiles.values.count(:black)
end

solve1

def solve2
  lines = Utils.input_read(24)
  directions = lines.map do |l|
    l.chomp.scan(/n[ew]{1}|s[we]{1}|e|w|/).select { |m| m != '' }
  end
  tiles = {}
  directions.each do |directions|
    final_coords = find_tile_coords(directions)
    key = final_coords.values.join('|')
    if tiles[key] && tiles[key] == :black
      tiles[key] = :white
    else
      tiles[key] = :black
    end
  end

  100.times do |i|
    next_map = tiles.clone
    tiles.each do |coords, color|
      x, y, z = coords.split("|").map(&:to_i)
      next_map[coords] = new_color({ x: x, y: y, z: z }, color, tiles)
      flip_neighbors({ x: x, y:y, z:z }, tiles, next_map)      
    end
    # puts next_map
    print "#{i} #{next_map.values.count(:black)}  \r"
    # gets
    tiles = next_map
  end
  puts ""
  puts tiles.values.count(:black)
end

solve2
