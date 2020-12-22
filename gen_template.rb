day = ARGV[0]

exit if File.exist?("day#{day}.rb")

File.write("day#{day}.rb", "require './utils'

def solve1
  lines = Utils.input_read(#{day})
end

solve1

def solve2
  lines = Utils.input_read(#{day})
end

solve2
")


File.write("./inputs/day#{day}.txt", "")