module Utils
  def self.input_read(day)
    File.foreach("./inputs/day#{day}.txt").map { |line| line }
  end
end