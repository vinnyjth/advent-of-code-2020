require './utils'


def solve1
  lines = Utils.input_read(2)
  valid_passwords = lines.filter do |pw|
    groups = pw.match(/(?<min>\d+)-(?<max>\d+) (?<char>\w): (?<password>\w+)/)
    char_count = groups[:password].count(groups[:char])
    char_count >= groups[:min].to_i && char_count <= groups[:max].to_i
  end
  puts "Part 1"
  puts valid_passwords.length
end

solve1

def solve2
  lines = Utils.input_read(2)
  valid_passwords = lines.filter do |pw|
    groups = pw.match(/(?<idx1>\d+)-(?<idx2>\d+) (?<char>\w): (?<password>\w+)/)
    first_char = groups[:password][groups[:idx1].to_i - 1]
    second_char = groups[:password][groups[:idx2].to_i - 1]
    (first_char == groups[:char] and second_char != groups[:char]) or (first_char != groups[:char] and second_char == groups[:char])
  end
  puts "Part 2"
  puts valid_passwords.length
end

solve2