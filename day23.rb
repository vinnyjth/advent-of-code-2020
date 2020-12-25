# Introducing "Cup", the worlds worst possible interpretation of a linked list
class Cup
  attr_accessor :value, :prev, :next
  def initialize(value, prev, next_val)
    @value = value
    @prev = prev
    @next = next_val
  end

  def append(target)
    old_next = @next
    @next = target
    old_next.prev = target if old_next
    target.prev = self
    target.next = old_next
  end

  def to_s
    "(cup #{@value} next: #{@next && @next.value} prev: #{@prev && @prev.value})"
  end

  def inspect
    to_s
  end

  def unlink
    @prev.next = @next if @prev
    @next.prev = @prev if @next
    @next = nil
    @prev = nil
  end
end

def turn(cups, max, current_cup)
  removed_cups = [current_cup.next, current_cup.next.next, current_cup.next.next.next]
  removed_cups.each { |c| c.unlink }
  removed_cups.each_with_index do |c, i|
    c.append(removed_cups[i + 1]) if removed_cups[i + 1]
  end

  target_cup = current_cup.value - 1

  destination_cup = nil
  while destination_cup == nil do
    if !removed_cups.map { |c| c.value }.include?(target_cup) && target_cup != 0
      destination_cup = target_cup
    elsif target_cup == 1 || target_cup == 0
      target_cup = max
    else
      target_cup -= 1
    end
  end

  insertion_cup = cups[destination_cup]

  old_next = insertion_cup.next

  insertion_cup.next = removed_cups.first
  removed_cups.first.prev = insertion_cup

  old_next.prev = removed_cups.last
  removed_cups.last.next = old_next

  current_cup.next
end

def make_cup_map(cup_array)
  last_val = nil
  cups = cup_array.inject({}) do |accum, (c, i)|
    if last_val
      accum[c] = Cup.new(c, last_val, nil)
    else
      accum[c] = Cup.new(c, nil, nil)
    end
    last_val = accum[c]
    accum
  end

  cups[cup_array.first].prev = cups[cup_array.last]

  cups.each do |value, c|
    cup = c.prev
    cup.next = c if cup
  end
  cups
end

def solve1
  lines = "739862541"
  cup_array = lines.split('').map(&:to_i)
  max_cup = cup_array.max

  cups = make_cup_map cup_array

  current_cup = cups[cup_array.first]

  100.times do |i|
    current_cup = turn(cups, max_cup, current_cup)
  end

  next_cup = cups[1]
  final_cups = []
  while final_cups.length < cup_array.length - 1
    next_cup = next_cup.next
    final_cups.push next_cup.value
  end

  pp final_cups
end
solve1

def solve2
  lines = "739862541"
  cup_array = lines.split('').map(&:to_i)
  max_cup = cup_array.max
  million_cups = Array.new(1000000 - max_cup).each_with_index.map { |_, i| i + max_cup + 1}
  cup_array = cup_array + million_cups

  cups = make_cup_map cup_array

  current_cup = cups[cup_array.first]
  start_time = Time.now
  10000000.times do |i|
    current_cup = turn(cups, 1000000, current_cup)
  end
  puts ""
  one_index = cups[1]
  puts one_index.next.value * one_index.next.next.value
end
solve2