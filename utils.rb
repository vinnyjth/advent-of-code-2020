module Utils
  def self.input_read(day)
    File.foreach("./inputs/day#{1}.txt").map { |line| line }
  end
end