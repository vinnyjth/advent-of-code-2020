require './utils'

def has_sum_pair?(set, target)
  set.any? do |l1|
    set.any? do |l2|
      l1 + l2 == target && l1 != l2
    end
  end
end

def solve1
  lines = Utils.input_read(9).map(&:to_i)
  preamble = 25
  result = lines.each_with_index.find do |line, idx|
    next if idx < preamble
    !has_sum_pair?(lines[(idx-preamble)...idx], line)
  end
  pp result
  result[0]
end

solve1

def solve2
  lines = Utils.input_read(9).map(&:to_i)
  target = solve1
  @range = []
  result = lines.each_with_index.find do |line, idx|
    sum = 0
    @range = []
    idxx = 0
    while sum < target
      sum += lines[idxx + idx]
      @range << lines[idxx + idx]
      idxx += 1
    end
    sum == target
  end
  pp @range
  pp @range.sort[0] + @range.sort[-1]
end


solve2