require './utils'


def solve1
  lines = Utils.input_read(14)
  mask = ""
  mem = {}
  lines.each do |line|
    parts = line.split(" = ")
    if parts[0] == 'mask'
      mask = parts[1]
    else
      mem[parts[0]] = 0 unless mem[parts[0]]

      rm = mask.chomp.chars.reverse
      input = parts[1].to_i.to_s(2).chomp.chars.reverse
      final = rm.each_with_index.map { |c, i| c != 'X' ? c : input[i] || 0 }.reverse.join('')

      mem[parts[0]] = final.to_i(2)
    end
  end
  puts mem.values.inject(0, :+)
end

# solve1

def solve2
  lines = Utils.input_read(14)
  mask = ""
  mem = {}
  lines.each do |line|
    parts = line.split(" = ")
    if parts[0] == 'mask'
      mask = parts[1]
    else
      mem_add = parts[0].match(/mem\[(\d+)\]/)[1]
      # puts mem_add
      # puts parts[1].to_i
      # mem[parts[0]] = 0 unless mem[parts[0]]

      rev_mask = mask.chomp.chars.reverse
      rev_mem_add = mem_add.to_i.to_s(2).chars.reverse
      # puts '---'
      # puts rev_mem_add.join
      # puts rev_mask.join
      # puts '---'
      x_count = rev_mask.count { |c| c == 'X' }
      x_permutations = [0, 1].repeated_permutation(x_count).to_a
      indexes = x_permutations.map do |perm|
        rev_mask.each_with_index.map {
          |c, i| c  == 'X' ? perm.pop : c == '1' ? '1' : rev_mem_add[i] || c
        }.reverse.join('').to_i(2)
      end
      indexes.each do |idx|
        # puts idx
        mem[idx] = parts[1].to_i
      end
      # puts "---------"
    end
  end
  puts mem.values.inject(0, :+)
end

solve2