require "./utils.cr"

class Infinite
  include Iterator(UInt64)
  @val : UInt64

  def initialize(@jump : Int32)
    @val = 0
  end

  def next
    @val += @jump
    @val
  end
end

def solve2
  input = "23,x,x,x,x,x,x,x,x,x,x,x,x,41,x,x,x,37,x,x,x,x,x,421,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,x,17,x,19,x,x,x,x,x,x,x,x,x,29,x,487,x,x,x,x,x,x,x,x,x,x,x,x,13"
  busses = input.split(',').each_with_index.map { |b| { b[0], b[1] } }
  final_busses = busses.reject { |b| b[0] == "x" }.map { |b| { b[0].to_i, b[1] } }.to_a

  biggest_bus = final_busses.max_by { |b| b[0] }

  inf = Infinite.new(biggest_bus[0])

  t = inf.find do |i|
    final_busses.all? {|b| (i + b[1] - biggest_bus[1]) % b[0] == 0 }
  end
  puts t
end


solve2