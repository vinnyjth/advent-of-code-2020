require './utils'

SIDE_MAP = { left: :right, right: :left, bottom: :top, top: :bottom }

def orient(map, rotation, flipped_horizontal, flipped_vertical)
  final_map = map
  if rotation
    rotation.times do
      final_map = map.transpose.map { |r| r.reverse }
    end
  end
  if flipped_vertical
    final_map = final_map.each_with_index.map { |r, i| final_map[final_map.length - i - 1] }
  end

  if flipped_horizontal
    final_map = final_map.map { |r| r.reverse }
  end
  final_map
end
class Tile
  attr_reader :id, :uid, :neighbors, :sides
  def initialize(data, rotation, flipped_horizontal, flipped_vertical)
    @data = data
    @id = get_id
    original_map = data.split("\n")[1..-1].map { |r| r.split("") }
    @rotation = rotation
    @flipped_horizontal = flipped_horizontal
    @flipped_vertical = flipped_vertical
    @map = orient(original_map, rotation, flipped_horizontal, flipped_vertical)
    @sides = {
      left: @map.map { |r| r.first },
      right: @map.map { |r| r.last },
      top: @map.first,
      bottom: @map.last,
    }
    @neighbors = {}
  end

  def get_id
    @data.split("\n")[0].split(" ")[1].gsub(":", "")
  end

  def uid
    @map.map { |r| r.join(',') }.join('-')
  end

  def to_s
    "<#Tile id=#{@id} rotation=#{@rotation} fh=#{@flipped_horizontal} fv=#{@flipped_vertical}>"
  end

  def inspect
    self.to_s
  end

  def display_map
    @map.map { |r| r[1...-1] }[1...-1]
  end

  def corner?
    @neighbors[:top].any? && @neighbors[:left].any? && @neighbors[:right].empty? && @neighbors[:bottom].empty? ||
    @neighbors[:bottom].any? && @neighbors[:left].any? && @neighbors[:right].empty? && @neighbors[:top].empty? ||
    @neighbors[:top].any? && @neighbors[:right].any? && @neighbors[:left].empty? && @neighbors[:bottom].empty? ||
    @neighbors[:bottom].any? && @neighbors[:right].any? && @neighbors[:left].empty? && @neighbors[:top].empty?
  end

  def set_neighbors(tiles)
    @neighbors = @sides.inject({ top: [], bottom: [], left: [], right: [] }) do |accum, (direction, edge)|
      neigh = tiles.select { |tile| tile.sides[SIDE_MAP[direction]] == edge && tile.id != @id }
      accum[direction].concat(neigh)
      accum
    end
  end

end

# def solve1
# end

# solve1


def is_snek?(map, x, y)
  snek = <<-SNEK
.#...#.###...#.##.O
O.##.OO#.#.OO.##.OOO
#O.#O#.O##O..O.#O
SNEK
  snek_array = snek.split("\n").map { |r| r.split("") }
  found_snek = snek_array.each_with_index.all? do |row, snek_y|
    good_row = row.each_with_index.all? do |ch, snek_x|
      check_x = x + snek_x
      check_y = y + snek_y
      row_good = true
      if check_y >= map.length || check_x >= map[check_y].length
        row_good = false
      elsif map[check_y][check_x] != '#' && ch == 'O'
        row_good = false
      end
      row_good
    end
    good_row
  end
  found_snek
end

def get_next_tile(map, x_cur, y_cur)
  next_tiles = [
    [1, 0, :left],
    [-1, 0, :right],
    [0, 1, :top],
    [0, -1, :bottom],
  ].map do |(x, y, direction)|
    new_y = y+y_cur
    new_x = x+x_cur
    if new_y < map.length && new_y >= 0 && new_x >= 0 && map[new_y][new_x]
      map[new_y][new_x].neighbors[direction]
    end
  end.flatten.reject { |n| n.nil? }
end

def solve2
  lines = Utils.input_read(20)
  tiles = lines.join("").split("\n\n").map do |t|
    [0, 1, 2, 3].map do |rotation|
      [false, true].map do |flipped_horizontal|
        [false, true].map do |flipped_vertical|
          Tile.new(t, rotation, flipped_horizontal, flipped_vertical)
        end
      end
    end
  end.flatten.uniq { |t| t.uid }

  map_size = Math.sqrt(lines.join("").split("\n\n").length).to_i

  tiles.each { |t| t.set_neighbors(tiles) }

  corners = tiles.select { |t| t.corner? }
  top_left_corner = corners.find { |c| c.neighbors[:bottom].any? && c.neighbors[:right].any? }

  map = Array.new(map_size) { Array.new(map_size) }

  map[0][0] = top_left_corner

  (0..(map_size - 1)).each do |y|
    (0..(map_size - 1)).each do |x|
      next if y == 0 && x == 0
      next_tile = get_next_tile(map, x, y)
      map[y][x] = next_tile[0]
    end
  end


  row_final = []
  map.each_with_index do |r, ri|
    tiles = r.map do |t|
      t.display_map
    end
    tiles.each_with_index do |t, i|
      t.each_with_index do |tr, tri|
        row_final[tri + (ri * t.length)] = [] unless row_final[tri + (ri * t.length)]
        row_final[tri + (ri * t.length)].concat(tr)
      end
    end
  end

  Utils.print_map(row_final)

  snek_map = [0, 1, 2, 3].find do |rotation|
    [false, true].find do |flipped_horizontal|
      [false, true].find do |flipped_vertical|
        snek_map = orient(row_final, rotation, flipped_horizontal, flipped_vertical)

        sneks = 0
        snek_map.each_with_index do |r, y|
          r.each_with_index do |_, x|
            is_snek = is_snek?(snek_map, x, y)
            sneks += 1 if is_snek
          end.to_a
        end.to_a
        # puts sneks
        if sneks > 0
          Utils.print_map(snek_map)
          waves = snek_map.map { |r| r.join('') }.join('').count('#')
          snek_waves = 15 * sneks
          pp "result"
          pp [waves - snek_waves, waves, snek_waves]
        end
      end
    end
  end
end

solve2
