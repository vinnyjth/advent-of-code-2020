require './utils'

class Tile
  attr_reader :id, :neighbors
  def initialize(data)
    @data = data
    @id = get_id
    @map = get_map
    @position
    @neighbor_result = {}
  end

  def get_id
    @data.split("\n")[0].split(" ")[1].gsub(":", "")
  end

  def get_map
    @data.split("\n")[1..-1].map { |r| r.split("") }
  end

  def side(direction, rotation = 0, flipped_vertical = false, flipped_horizontal = false)
    rotation_mod = (direction + rotation) % 4
    side = nil

    map = @map

    case rotation_mod
    when 0
      if flipped_vertical
        side = map.last
      else
        side = @map[0]
      end
    when 1
      if flipped_horizontal
        side = @map.map { |r| r.first }
      else
        side = @map.map { |r| r.last }
      end
    when 2
      if flipped_vertical
        side = map.first
      else
        side = @map.last
      end
    when 3
      if flipped_horizontal
        side = @map.map { |r| r.last }
      else
        side = @map.map { |r| r.first }
      end
    end

    if (direction % 2 == 0 && (2..3).include?(rotation)) || (direction % 2 == 1 && (1..2).include?(rotation))
      side = side.reverse
    end

    if rotation_mod % 2 == 0 && flipped_horizontal
      side = side.reverse
    elsif rotation_mod % 2 == 1 && flipped_vertical
      side = side.reverse
    end

    { side: side, rotation: rotation, direction: direction, rot_mod: rotation_mod, flipped_vertical: flipped_vertical, flipped_horizontal: flipped_horizontal }
  end

  def sides(rotation = 0, flipped_vertical = false, flipped_horizontal = false)
    (0..3).map { |d| side(d, rotation, flipped_vertical, flipped_horizontal) }
  end

  def rotated_sides(flipped_vertical = false, flipped_horizontal = false)
     (0..3).map { |rotation| sides(rotation, flipped_vertical, flipped_horizontal) }.flatten(1)
  end

  def flipped_rotated_sides
    return @sides if @sides
    @sides = [false, true].map do |vertical|
      [false, true].map do |horizontal|
        rotated_sides(vertical, horizontal)
      end
    end.flatten(2)
    return @sides
  end

  def to_s
    @id
  end

  def inspect
    @id
  end

  # def pretty
  #   side(1).times do |i|
  #   end
  # end

  def intersects?(tile)
    return false if tile.id == @id
    # pp rotated_side
    rotated_sides.any? { |side| tile.sides.any? { |their_side| their_side[:side] == side[:side] } }
  end

  def intersections(tile)
    return [] if tile.id == @id
    # pp rotated_side
    sides = flipped_rotated_sides.map { |side| tile.flipped_rotated_sides.map { |their_side| { theirs: their_side, ours: side, match: their_side[:side] == side[:side] } } }
    sides = sides.flatten.select { |s| s[:match] }
    sides
  end

  def intersections_reversed(tile)
    return [] if tile.id == @id
    # pp rotated_side
    tile.flipped_rotated_sides.filter { |their_side| flipped_rotated_sides.any? { |our_side| their_side[:side] == our_side[:side] } }
  end

  def find_neighbors(tiles)
    @neighbors = tiles.find_all { |t| intersects?(t) }
  end

  def draw(rotation = 0, flipped_vertical = false, flipped_horizontal = false)
    image = @map.clone.map { |r| r.clone }
    if rotation
      rotation.times do
        image = image.transpose.map { |r| r.reverse }
      end
    end
    if flipped_vertical
      image = image.each_with_index.map { |r, i| image[image.length - i - 1] }
    end

    if flipped_horizontal
      image = image.map { |r| r.reverse }
    end

    image = image.push Array.new(image.length, ' ')
    image = image.unshift Array.new(image.length - 1, ' ')
    image = image.map do |row|
      row = row.push ' '
      row = row.unshift ' '
    end
    image
  end

  def find_neighbors_with_edges(tiles)
    return @neighbors if @neighbors
    edges = tiles.map { |t| { edges: intersections(t), neighbor: t } }
    valid_edges = edges.filter { |e| e[:edges].length > 0 }

    all_edges = valid_edges.map { |e| e[:edges] }.flatten
    grouped_properties = all_edges.group_by { |e| { r: e[:rotation], fv: e[:flipped_vertical], fh: e[:flipped_horizontal] } }
    valid_properties = grouped_properties.find_all { |k, v| v.length == valid_edges.length }

    valid_edges = valid_edges.map do |ve|
      filtered_edges = ve[:edges].filter { |e| valid_edges.all? { |eva| eva[:edges].any? { |fe| e[:rotation] == fe[:rotation] && e[:flipped_vertical] == fe[:flipped_vertical] && e[:flipped_horizontal] == fe[:flipped_horizontal] } } }
      # uniq_edges = filtered_edges.uniq { |e| e[:side] }
      # puts filtered_edges.length
      # puts ve[:edges].length
      { tile: ve[:neighbor], edges: filtered_edges, from: self }
    end

    # puts grouped_properties.map { |k, v| [k, v.length] }
    # puts valid_edges.length
    # puts "-------"
    @neighbors = valid_edges
    @neighbors
  end

#   def pick_neighbor(direction, tiles, excluded = [])
#     edges = find_neighbors_with_edges(tiles)
#     neighbor_edge = edges.find do |n|
#       n[:edges].find do |e|
#         if @position
#           e[:direction] == direction &&
#           e[:rotation] == @position[:r] &&
#           e[:flipped_horizontal] == @position[:fh] &&
#           e[:flipped_vertical] == @position[:fv] &&
#           !excluded.include?(n[:tile].id)
#         else
#           e[:direction] == direction &&
#           !excluded.include?(n[:tile].id)
#         end
#       end
#     end
#     # pp @position
#     # pp neighbor_edge[:edges].find { |e| e[:direction] == direction }
#     unless @position
#       neighbor_side = neighbor_edge[:edges].find { |e| e[:direction] == direction }
#       @position = {
#         r: neighbor_side[:rotation],
#         fh: neighbor_side[:flipped_horizontal],
#         fv: neighbor_side[:flipped_vertical],
#       }
#     end
#     neighbor_edge
#   end
# end

  def pick_neighbors(direction, tiles, excluded = [], our_position = nil, their_position = nil)
    # pp our_position, their_position
    cache_key = [direction, tiles, excluded, our_position, their_position].to_s
    pp cache_key
    return @neighbor_result[cache_key] if @neighbor_result[cache_key]
    edges = find_neighbors_with_edges(tiles)
    neighbor_edges = edges.map do |n|
      edges = n[:edges].select do |e|
        should_include = true
        if our_position && their_position
          e[:theirs][:direction] == direction &&
          e[:ours][:rotation] == our_position[:rotation] &&
          e[:ours][:flipped_horizontal] == our_position[:flipped_horizontal] &&
          e[:ours][:flipped_vertical] == our_position[:flipped_vertical]
          e[:theirs][:rotation] == their_position[:rotation] &&
          e[:theirs][:flipped_horizontal] == their_position[:flipped_horizontal] &&
          e[:theirs][:flipped_vertical] == their_position[:flipped_vertical] &&
          !excluded.include?(n[:tile].id)
        elsif our_position
          e[:ours][:direction] == direction &&
          e[:ours][:rotation] == our_position[:rotation] &&
          e[:ours][:flipped_horizontal] == our_position[:flipped_horizontal] &&
          e[:ours][:flipped_vertical] == our_position[:flipped_vertical]
          !excluded.include?(n[:tile].id)
        elsif their_position
          e[:theirs][:direction] == direction &&
          e[:theirs][:rotation] == their_position[:rotation] &&
          e[:theirs][:flipped_horizontal] == their_position[:flipped_horizontal] &&
          e[:theirs][:flipped_vertical] == their_position[:flipped_vertical] &&
          !excluded.include?(n[:tile].id)
        else
          e[:ours][:direction] == direction &&
          !excluded.include?(n[:tile].id)
        end
        # should_include
        # true
      end
      { edges: edges, tile: n[:tile], from: n[:from] }
    end.filter { |e| e[:edges].length > 0 }
    result = neighbor_edges.map { |e| e[:edges].map { |desc| { tile: e[:tile], from: e[:from] }.merge(desc) } }.flatten
    @neighbor_result[cache_key] = result
    result
  end
end

def solve1
  lines = Utils.input_read(20)
  tiles = lines.join("").split("\n\n").map { |t| Tile.new(t) }
  tiles.each {|t| t.find_neighbors tiles }
  puts tiles.filter { |t| t.neighbors.count == 2 }.map { |t| t.id.to_i }.reduce(1, &:*)
end

# solve1

OFFSET_MAP_X = {
  -1 => 1,
  1 => 3,
}

OFFSET_MAP_Y = {
  -1 => 2,
  1 => 0
}

def solve2
  lines = Utils.input_read(20)
  tiles = lines.join("").split("\n\n").map { |t| Tile.new(t) }
  tiles_with_edges = tiles.map {|t| { 
    edges: t.find_neighbors_with_edges(tiles),
    tile: t
  } }
  corners = tiles_with_edges.filter { |t| t[:edges].length == 2 }

  map_size = Math.sqrt(tiles.length).to_i
  map = Array.new(map_size) { Array.new(map_size, '.')  }


  # first_corner = corners[0]
  # corners[0][:edges] =
  # map[0][0] = corners[0][:tile]
  # # pp corners[0]
  # map[0][0].draw
  # map[0][1] = map[0][0].pick_neighbor(1, tiles)[:neighbor]
  # map[0][1].draw
  # map[1][0] = map[0][0].pick_neighbor(2, tiles)[:neighbor]
  # pp corners[0][:edges][0][":"]

  first_corner = corners[0][:edges].map { |e| e[:edges].map { |desc| { tile: corners[0][:tile] }.merge(desc)  } }.flatten

  # pp first_corner
  stack = first_corner
  excluded = []
  current_location = [0, 0];
  # map[0][0] = first_corner[0]
  visited = {}

  loop do
    current_node = stack.pop

    # puts ({
    #   tile: current_node[:tile],
    #   rotation: current_node[:rotation],
    #   flipped_vertical: current_node[:flipped_vertical],
    #   flipped_horizontal: current_node[:flipped_horizontal],
    # })

    # puts current_location

    # pp excluded
    # pp current_node[:tile]
    break if current_node == nil
    excluded = map.flatten.map { |t| t != '.' ? t[:tile].id : t }
    # puts excluded
    # pp current_node
    # next_edges = current_node[:tile].pick_neighbor(1, tiles, excluded)
    position = current_node[:ours][:rotation] && current_node[:ours][:flipped_vertical] && current_node[:ours][:flipped_horizontal] ? current_node[:ours] : nil

    reversed = current_location[0] % 2 == 1

    # direction = current_location[1] == (map_size - 1) ? 2 : (reversed ? 1 : 3)

    # puts current_location
    direction = reversed ? 3 : 1
    direction = 2 if (reversed && current_location[1] == 0) || (!reversed && current_location[1] == map_size - 1)

    current_offset = current_location[1] == (map_size - 1) ? { x: 0, y: -1 } : (reversed ? { x: 1, y: 0 } : { x: -1, y: 0 })

    # puts stack
    # puts current_node[:tile]
    # puts excluded.include? current_node[:tile].id
    # pp excluded

    neighbors = (-1..1).map do |y|
      (-1..1).map do |x|
        x_off = x + current_location[1]
        y_off = y + current_location[0]
        if x_off >= 0 && x_off < map_size && y_off >= 0 && y_off < map_size && x.abs != y.abs && x.abs + y.abs == 1
          { x: x, y: y, tile: map[y_off][x_off] } if map[y_off][x_off] != '.'
        end
      end
    end.flatten(1).reject { |v| v.nil? }
    # puts current_location
    # if neighbors.length == 0
    #   neighbors.push({ tile: current_node }.merge(current_offset))
    # end
    # puts current_location
    next_edges = current_node[:tile].pick_neighbors(direction, tiles, excluded, position)
    # puts "-----"
    # puts 'Sample next_edges'
    # puts next_edges.first
    # puts "-----"
    # puts next_edges
    # puts "edges"
    # puts next_edges.length
    # puts "stack"
    # puts stack.length
    # puts "----"
    # puts direction
    # puts "----"

    # pp current_node
    valid_with_neighbors = neighbors.all? do |n|
      # pp [n[:x], n[:y]]
      n_dir = n[:x] != 0 ? OFFSET_MAP_X[n[:x]] : OFFSET_MAP_Y[n[:y]]
      # puts n_dir
      # puts n[:x]
      tile = n[:tile]
      n_pos = tile[:ours][:rotation] && tile[:ours][:flipped_vertical] && tile[:ours][:flipped_horizontal] ? tile[:ours] : nil
      res = tile[:tile].pick_neighbors(n_dir, tiles, [], n_pos, position).select { |e| e[:tile].id == current_node[:tile].id }
      # pp [n[:tile], n_pos, n_dir, n[:y], n[:x]]
      # pp position
      # puts "---"
      # puts n_dir
      # puts "---"
      # pp current_node      
      # puts res
      # puts res.length
      res.length > 0
    end
    # puts neighbors.length

    # puts next_edges

    # next_edges = next_edges.filter do |edge|
    #   neighbors.all? do |n|
    #     n_dir = n[:x] != 0 ? OFFSET_MAP_X[n[:x]] : OFFSET_MAP_Y[n[:x]]
    #     # puts n_dir
    #     # puts n[:x]
    #     tile = n[:tile]
    #     n_pos = tile[:ours][:rotation] && tile[:ours][:flipped_vertical] && tile[:ours][:flipped_horizontal] ? tile : nil
    #     # o_pos = tile[:theirs][:rotation] && tile[:theirs][:flipped_vertical] && tile[:theirs][:flipped_horizontal] ? tile : nil
    #     tile[:tile].pick_neighbors(n_dir, tiles, excluded, position, n_pos).length > 0
    #   end
    # end
    # puts "-------"
    # puts "-------"
    # puts "current" 
    # puts current_node
    # puts "neighbors"

    # puts next_edges.count { |e| visited[current_location.to_s].any? { |v| v == {
    #   tile: e[:tile].id,
    #   rotation: e[:rotation],
    #   flipped_vertical: e[:flipped_vertical],
    #   flipped_horizontal: e[:flipped_horizontal],
    # }} }
    visited[current_location.to_s] ||= []    
    next_edges = next_edges.reject { |e| visited[current_location.to_s].any? { |v| v == {
      tile: e[:tile].id,
      rotation: e[:ours][:rotation],
      flipped_vertical: e[:ours][:flipped_vertical],
      flipped_horizontal: e[:ours][:flipped_horizontal],
      t_tile: e[:from],
      t_rotation: e[:theirs][:rotation],
      t_flipped_vertical: e[:theirs][:flipped_vertical],
      t_flipped_horizontal: e[:theirs][:flipped_horizontal],      
    } } }

    # puts "next"
    # puts stack
    valid_placement = !excluded.include?(current_node[:tile].id) ||
                      (map[current_location[0]][current_location[1]] != '.' && map[current_location[0]][current_location[1]][:tile].id == current_node[:tile].id)


    # pp current_location
    # path_forward =  || current_location == [map.length - 1, map.length - 1]

    if next_edges.length == 0 && current_node[:tile].id == '1171'
      puts "done!"
    end

    if valid_placement && valid_with_neighbors
    # if next_edges.length && !excluded.include?(current_node[:tile].id)
    #   puts current_location, reversed
      map[current_location[0]][current_location[1]] = current_node
      stack += next_edges
      if current_location[1] == (map_size - 1) && !reversed
        current_location = [current_location[0] + 1, map_size - 1]
      elsif current_location[1] == 0 && reversed
        current_location = [current_location[0] + 1, 0]
      else
        current_location[1] += (reversed ? -1 : +1)
      end
    elsif stack.last[:from] && stack.last[:from].id == current_node[:from].id

    else
      # puts current_location
      map[current_location[0]][current_location[1]] = '.'
      if current_location[1] == 0 && current_location[0] == 0
        # Do nothing
      elsif current_location[1] == 0 && !reversed
        current_location = [current_location[0] - 1, 0]
      elsif current_location[1] == (map_size - 1) && reversed
        current_location = [current_location[0] - 1, (map_size -1)]
      else
        current_location[1] += (reversed ? 1 : -1)
      end
    end

    visited[current_location.to_s] ||= []
    visited[current_location.to_s].push({
      tile: current_node[:tile].id,
      rotation: current_node[:ours][:rotation],
      flipped_vertical: current_node[:ours][:flipped_vertical],
      flipped_horizontal: current_node[:ours][:flipped_horizontal],
      t_tile: current_node[:from],
      t_rotation: current_node[:theirs][:rotation],
      t_flipped_vertical: current_node[:theirs][:flipped_vertical],
      t_flipped_horizontal: current_node[:theirs][:flipped_horizontal],
    })

    # puts "edges"
    # puts next_edges
    # puts "neighbors"
    # puts neighbors
    # puts "neighbor_edges"
    # puts next_edges.length
    # puts "stack"
    # puts stack
    # puts current_location
    # puts "current_node"
    # pp current_node
    # pp valid_placement
    # pp next_edges.length
    # pp visited
    # puts "map"
    Utils.print_map(map.map { |r| r.map{ |t| t != '.' ? t[:tile] : '.'}})
    # gets
    break if current_location == [map_size, map_size - 1]
    # break
    # puts next_edges
    # puts "---"
    # puts "last direction"
    pp direction
    # puts "---"

  end
  # pp stack
  puts map
  row_final = []
  map.each_with_index do |r, ri|
    tiles = r.map do |t|
      rotation = t[:ours][:rotation]
      flipped_vertical = t[:ours][:flipped_vertical]
      flipped_horizontal = t[:ours][:flipped_horizontal]
      t[:tile].draw(rotation, flipped_vertical, flipped_horizontal)
    end
    tiles.each_with_index do |t, i|
      t.each_with_index do |tr, tri|
        row_final[tri + (ri * t.length)] = Array.new(map.length * r.length) unless row_final[tri + (ri * t.length)]
        row_final[tri + (ri * t.length)].concat(tr)
      end
    end
  end
  # pp row_final
  Utils.print_map(row_final)
  Utils.print_map(map.map { |r| r.map{ |t| t != '.' ? t[:tile] : '.'}})
end

solve2
