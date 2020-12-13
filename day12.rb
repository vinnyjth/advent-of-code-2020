require './utils'

@positions = [{ x: 1, y: 0 }, { x: 0, y: -1 }, { x: -1, y: 0 }, { x: 0, y: 1 }]

def solve1
  directions = Utils.input_read(12)
  facing = { x: 1, y: 0 }
  location = { x: 0, y: 0 }
  directions.each do |dir|
    instruction = dir[0]
    amount = dir[1..-1].to_i
    case instruction
    when 'F'
      location[:x] += facing[:x] * amount
      location[:y] += facing[:y] * amount
    when 'N'
      location[:y] += amount
    when 'S'
      location[:y] -= amount
    when 'E'
      location[:x] += amount
    when 'W'
      location[:x] -= amount
    when 'L'
      times = amount / 90
      current_index = @positions.find_index { |pos| pos[:x] == facing[:x] && pos[:y] == facing[:y] }
      facing = @positions[(current_index - times) % 4]
    when 'R'
      times = amount / 90
      current_index = @positions.find_index { |pos| pos[:x] == facing[:x] && pos[:y] == facing[:y] }
      facing = @positions[(current_index + times) % 4]
    end
  end
  puts location[:x].abs + location[:y].abs
end

solve1

def rotate(x, y, degrees)
  radians = degrees * Math::PI/180
  cos = Math.cos(radians);
  sin = Math.sin(radians);
  {
    x: (x * cos - y * sin),
    y: (x * sin + y * cos)
  }
end

def solve2
  directions = Utils.input_read(12)
  facing = { x: 1, y: 0 }
  location = { x: 0, y: 0 }
  waypoint = { x: 10, y: 1 }
  directions.each do |dir|
    instruction = dir[0]
    amount = dir[1..-1].to_i
    case instruction
    when 'F'
      location[:x] += waypoint[:x] * amount
      location[:y] += waypoint[:y] * amount
    when 'N'
      waypoint[:y] += amount
    when 'S'
      waypoint[:y] -= amount
    when 'E'
      waypoint[:x] += amount
    when 'W'
      waypoint[:x] -= amount
    when 'L'
      degrees = amount
      new_direction = rotate(waypoint[:x], waypoint[:y], degrees)
      puts degrees, new_direction
      waypoint = new_direction
    when 'R'
      degrees = amount * -1
      new_direction = rotate(waypoint[:x], waypoint[:y], degrees)
      puts degrees, new_direction
      waypoint = new_direction
    end
  end
  puts location[:x], location[:y]
  puts location[:x].abs + location[:y].abs
end


solve2