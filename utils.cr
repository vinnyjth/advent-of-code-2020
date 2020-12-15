module Utils
  def self.input_read(day)
    File.foreach("./inputs/day#{day}.txt").map { |line| line }
  end

  def self.input_to_lines(input)
    input.split("\n")
  end
end