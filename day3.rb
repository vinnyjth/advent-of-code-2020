require './utils'

# @lines = Utils.input_to_lines("..##.......
# #...#...#..
# .#....#..#.
# ..#.#...#.#
# .#...##..#.
# ..#.##.....
# .#.#.#....#
# .#........#
# #.##...#...
# #...##....#
# .#..#...#.#
# ")

def solve1
  lines = Utils.input_read(3)
  trees = 0
  lines.each_with_index do |line, y|
    trees += 1 if line.chomp.chars[(y * 3) % (line.chomp.chars.length)] == '#'
  end
  puts trees
end

solve1

def count_trees(right:, down: 1, rows:)
  trees = 0
  rows.each_with_index do |line, y|
    next if y % down != 0
    trees += 1 if line.chomp.chars[(y * right) % (line.chomp.chars.length)] == '#'
  end
  trees
end

def solve2
  lines = Utils.input_read(3)
  # lines = @lines
  trees = [
    count_trees(rows: lines, right: 1),
    count_trees(rows: lines, right: 3),
    count_trees(rows: lines, right: 5),
    count_trees(rows: lines, right: 7),
    count_trees(rows: lines, right: 7, down: 2),
  ]
  puts trees.inject(:*)
end

solve2