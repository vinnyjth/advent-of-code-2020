require './utils'

def solve1
  decks = Utils.input_read(22).join('').split("\n\n")
  decks = decks.map do |d|
    d.split("\n")[1..-1].map(&:to_i)
  end
  p1 = decks[0]
  p2 = decks[1]
  while p1.length != 0 && p2.length != 0
    p1c = p1.shift
    p2c = p2.shift
    if p1c > p2c
      p1.concat([p1c, p2c])
    else
      p2.concat([p2c, p1c])
    end
  end
  pp p1.reverse.each_with_index.map { |c, i| c * (i+1) }.inject(0, &:+)
  pp p2.reverse.each_with_index.map { |c, i| c * (i+1) }.inject(0, &:+)
end


def play_game(p1, p2, stake1, stake2, depth)
  configurations = []
  p1 = p1.clone
  p2 = p2.clone
  while p1.length != 0 && p2.length != 0
    if configurations.include? (p1 + ['-'] + p2).to_s
      # puts "been here!"
      return [[stake1, stake2], [], p1]
    end

    configurations.push (p1 + ['-'] + p2).to_s

    p1c = p1.shift
    p2c = p2.shift

    if p1c > p1.length || p2c > p2.length
      if p1c > p2c
        p1.concat([p1c, p2c])
      else
        p2.concat([p2c, p1c])
      end
    else
      p1Wins, p2Wins = play_game(p1.take(p1c), p2.take(p2c), p1c, p2c, depth + 1)
      p1.concat(p1Wins)
      p2.concat(p2Wins)
    end
    # pp p1.join(', ')
    # pp p2.join(', ')
    # gets
  end
  if p1.length > 0
    [[stake1, stake2], [], p1]
  else
    [[], [stake2, stake1], p2]
  end
end

def solve2
  decks = Utils.input_read(22).join('').split("\n\n")
  decks = decks.map do |d|
    d.split("\n")[1..-1].map(&:to_i)
  end
  p1 = decks[0]
  p2 = decks[1]

  _, _, winning_deck = play_game(p1, p2, 'a', 'b', 0)
  # pp p1.reverse.each_with_index.map { |c, i| c * (i+1) }.inject(0, &:+)
  puts winning_deck.join(", ")
  pp winning_deck.reverse.each_with_index.map { |c, i| c * (i+1) }.inject(0, &:+)
end

solve2
