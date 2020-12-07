require './utils'

class Bag
  def initialize(bag_name)
    @bag_name = bag_name
    @capacity = {}
  end

  def add_capacity(bag, quantity)
    @capacity[bag] = quantity.to_i
  end

  def can_contain_bag?(all_bags, bag_color)
    return @capacity if @capacity.keys.include?(bag_color)
    child_bags = all_bags.filter do |bag|
      (@capacity.keys.include? bag.name) && (bag.name != @bag_name)
    end
    child_bags.any? { |b| b.can_contain_bag? all_bags, bag_color }
  end

  def inner_bag_count(all_bags)
    child_bags = all_bags.filter do |bag|
      (@capacity.keys.include? bag.name) && (bag.name != @bag_name)
    end
    # puts child_bags.join(', ')
    return 1 if child_bags.length == 0
    inner_bag_counts = child_bags.map do |bag|
      # puts bag, @capacity
      @capacity[bag.name] * bag.inner_bag_count(all_bags)
    end
    # puts inner_bag_counts, @bag_name, (inner_bag_counts.inject(&:+))
    # puts inner_bag_counts
    inner_bag_counts.inject(&:+) + 1
  end

  # def can_contain_bag_with_count?(all_bags, bag_color)
  #   return @capacity[bag_color] if @capacity.keys.include?(bag_color)
  #   child_bags = all_bags.filter do |bag|
  #     (@capacity.keys.include? bag.name) && (bag.name != @bag_name)
  #   end
  #   child_bags.any? { |b| b.can_contain_bag? all_bags, bag_color }
  # end  

  def name
    @bag_name
  end

  def to_s
    "#{@bag_name}: #{@capacity.map {|k, v| "#{k} - #{v}"}}"
  end
end

def solve1
  lines = Utils.input_read(7)
  bags = lines.map do |line|
    bag_name = line.split(" bags contain")[0]
    contains = line.split(" bags contain")[1].split(',').map { |b| b.match(/(?<number_bags>\d+) (?<bag_color>\w+ \w+) bag/) }
    bag = Bag.new(bag_name)
    contains.each do |cap|
      bag.add_capacity(cap[:bag_color], cap[:number_bags]) unless cap.nil?
    end
    bag
  end
  valid_bags = bags.filter { |b| b.can_contain_bag?(bags, "shiny gold") }
  # puts valid_bags
  # puts valid_bags.count
end

solve1

def solve2
  lines = Utils.input_read(7)
  bags = lines.map do |line|
    bag_name = line.split(" bags contain")[0]
    contains = line.split(" bags contain")[1].split(',').map { |b| b.match(/(?<number_bags>\d+) (?<bag_color>\w+ \w+) bag/) }
    bag = Bag.new(bag_name)
    contains.each do |cap|
      bag.add_capacity(cap[:bag_color], cap[:number_bags]) unless cap.nil?
    end
    bag
  end
  bag = bags.find { |b| b.name == "shiny gold" }
  puts bag.inner_bag_count(bags) - 1
end

solve2