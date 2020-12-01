require './utils'


def solve
  @lines = Utils.input_read(1)
  @lines.each do |x1|
    @lines.each do |x2|
      @lines.each do |x3|
        if (x1.to_i + x2.to_i + x3.to_i) == 2020
          puts  x1.to_i * x2.to_i * x3.to_i
        end
      end
    end
  end
end

solve