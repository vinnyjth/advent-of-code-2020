require './utils'

class Food
  attr_accessor :ingredients, :allergens
  def initialize(input)
    @ingredients = input.split("(contains")[0].split(" ")
    @allergens = input.split("(contains ")[1].gsub(")", "").chomp.split(", ")
  end
  def to_s
    "Ingredients: #{@ingredients} - Allergens:#{@allergens}"
  end
end

def solve1
  lines = Utils.input_read(21)
  foods = lines.map { |f| Food.new(f) }
  language = []
  allergen_ingredients = []
  last_length = nil
  while allergen_ingredients.length != last_length do
    last_length = allergen_ingredients.length
    foods.each do |food1|
      foods.each do |food2|
        next if food1 == food2
        common_allergens = food1.allergens & food2.allergens
        common_ingredients = food1.ingredients & food2.ingredients

        common_ingredients = common_ingredients.take(common_allergens.length)
        common_allergens.each do |a|
          food1.allergens.delete(a)
          food2.allergens.delete(a)
        end
        common_ingredients.each do |i|
          food1.ingredients.delete(i)
          food2.ingredients.delete(i)
        end
        language.push([common_allergens, common_ingredients]) if common_allergens.length > 0
        allergen_ingredients.concat(common_ingredients)
      end
    end

    foods.each do |food|
      food.ingredients = food.ingredients.reject { |i| allergen_ingredients.include?(i) }
      if food.allergens.length == food.ingredients.length
        allergen_ingredients.concat(food.ingredients)
        food.ingredients = []
        food.allergens = []
        language.push([food.allergens, food.ingredients])
      end
    end
  end

  pp foods.map { |f| f.ingredients - allergen_ingredients }.flatten.length
  puts foods
  pp language
  pp allergen_ingredients
end

solve1

def solve2
  lines = Utils.input_read(21)
end

solve2
