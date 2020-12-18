require './utils'

def solve(string)
  result = 0
  stack = []
  string.gsub(/[\(\)]/, '').split(' ').each do |c|
    if (['*', '+'].include? c)
      stack.push(c)
    elsif stack.length < 2
      stack.push(c.to_i)
    else
      # print c, stack[1], stack[0], "\n"
      compute = c.to_i.send(stack[1], stack[0])
      # puts compute
      stack = [compute]
    end
  end
  stack.first
end

def simplify(string)
  string.gsub(/\((\d+ [+*] ?)+\d+\)/) { |part| solve(part) }
end

def compute(string)
  while string.split(' ').length != 1 do
    string = simplify(string)
  end
  string
end

def day1
  lines = Utils.input_read(18)
  answers = lines.map { |l| compute("(#{l.chomp})") }
end

day1


def solve2(string)
  while string.count('+') != 0 do
    string = string.gsub(/\d+ \+ \d+/) { |g| g.split('+').map(&:to_i).inject(0, &:+) }
  end
  while string.count('*') != 0 do
    string = string.gsub(/\d+ \* \d+/) { |g| g.split('*').map(&:to_i).inject(1, &:*) }  
  end
  string.gsub(/[\(\)]/, '')
end

def simplify2(string)
  string.gsub(/\((\d+ [+*] ?)+\d+\)/) { |part| solve2(part) }
end

def compute2(string)
  while string.split(' ').length != 1 do
    puts string
    string = simplify2(string)
  end
  string
end

def day2
  lines = Utils.input_read(18)
  answers = lines.map { |l| compute2("(#{l.chomp})") }
  puts answers.inject(0) { |accum, a| a.to_i + accum}
end

day2