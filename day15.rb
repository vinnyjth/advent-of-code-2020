require './utils'

def solve(turns)
  input = "0,13,16,17,1,10,6".split(',').map(&:to_i)
  numbers = {}
  last_number_spoken = nil
  (1..turns).each do |turn|
    final_num = nil
    if input[turn -1]
      final_num = input[turn -1]
    else
      if !numbers[last_number_spoken] || numbers[last_number_spoken].length <= 1
        final_num = 0
      else
        turns_apart = (turn - 1) - (numbers[last_number_spoken][-2])
        final_num = turns_apart
      end
    end
    print '.' if turn % 100000  == 0

    numbers[final_num] = [] unless numbers[final_num]
    numbers[final_num].push(turn)

    last_number_spoken = final_num
  end
  spoken.last
end

def solve1
  puts solve(2020)
end

solve1

def solve2
  puts solve(30000000)
end

solve2