require './utils'


def solve1
  lines = Utils.input_read(6)
  passports = lines.join("").split("\n\n")
  puts passports.inject(0) { |sum, pp| pp.strip.gsub(/\n/, '').split("").uniq.length + sum }
end

solve1

def solve2
  lines = Utils.input_read(6)
  passports = lines.join("").split("\n\n")
  puts passports.inject(0) { |sum, pp|
    results_polled = pp.split.length
    uniq_answers = pp.strip.gsub(/\n/, '').split('').group_by { |c| c }.values
    uniq_answers.filter { |a| a.length == results_polled }.length + sum
  }
end


solve2