require './utils'


def solve1
  lines = Utils.input_read(10).map(&:to_i)
  lines = lines.sort.unshift(0)
  differences = { 1 => 0, 2 => 0, 3 => 1}
  lines.each_with_index do |line, i|
    next if lines[i +1].nil?
    diff = lines[i + 1] - line
    differences[diff] += 1
  end
  pp differences
  pp differences[1] * differences[3]
end

solve1

def solve2
  lines = Utils.input_read(10).map(&:to_i)
  lines = lines.sort.unshift(0)
  path_map = { 0 => 1 }
  lines.each_with_index do |line, i|
    next if lines[i+1].nil?
    current_value = path_map[line]
    (1..3).each do |x|
      next if lines[i+x].nil?
      current_line = lines[i+x]
      puts current_line
      if current_line <= line + 3
        path_map[current_line] = 0 if path_map[current_line].nil?
        path_map[current_line] += current_value
      end
    end
  end
  puts path_map
end


solve2