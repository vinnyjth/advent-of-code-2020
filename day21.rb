require './utils'

class Food
  attr_accessor :ingredients, :allergies
  def initialize(input)
    @ingredients = input.split("(contains")[0].split(" ")
    @allergies = input.split("(contains ")[1].gsub(")", "").chomp.split(", ")
  end
  def to_s
    "Ingredients: #{@ingredients} - Allergies:#{@allergies}"
  end
end

def solve1
  lines = Utils.input_read(21)
  foods = lines.map { |f| Food.new(f) }
  language = []
  allergen_ingredients = []
  all_allergies = foods.map { |f| f.allergies }.flatten.uniq
  all_ingredients = foods.map { |f| f.ingredients }.flatten.uniq

  last_safe_ingredients = nil
  while foods.map { |f| f.ingredients }.flatten.length != last_safe_ingredients
    last_safe_ingredients = foods.map { |f| f.ingredients }.flatten.length
    all_allergies.each do |a|
      foods_with_allergies = foods.select { |f| f.allergies.include? a }
      puts a
      puts foods_with_allergies
      if foods_with_allergies.length > 0
        shared_ingredients = foods_with_allergies.map {|f| f.ingredients }.inject(foods_with_allergies.first.ingredients, &:&)
        puts shared_ingredients
        if shared_ingredients.length == 1
          allergen_ingredients.push([shared_ingredients.first, a])
          foods.each { |f| f.ingredients.delete(shared_ingredients.first) }
          foods.each { |f| f.allergies.delete(a) }
        end
      end
    end
  end
  # all_allergies.each do |a|
  #   foods_with_allergies = foods.select { |f| f.allergies.include? a }
  #   puts a
  #   puts foods_with_allergies
  #   if foods_with_allergies.length > 0
  #     shared_ingredients = foods_with_allergies.map {|f| f.ingredients }.inject(foods_with_allergies.first.ingredients, &:&)
  #     puts shared_ingredients
  #     if shared_ingredients.length == 1
  #       allergen_ingredients.push([shared_ingredients.first, a])
  #       foods.each { |f| f.ingredients.delete(shared_ingredients.first) }
  #       foods.each { |f| f.allergies.delete(a) }
  #     end
  #   end
  # end
  # puts foods
  # last_length = nil
  # while allergen_ingredients.length != last_length do
  #   last_length = allergen_ingredients.length
  #   foods.each do |food1|
  #     foods.each do |food2|
  #       next if food1 == food2
  #       common_allergens = food1.allergens & food2.allergens
  #       common_ingredients = food1.ingredients & food2.ingredients

  #       common_ingredients = common_ingredients.take(common_allergens.length)
  #       common_allergens.each do |a|
  #         food1.allergens.delete(a)
  #         food2.allergens.delete(a)
  #       end
  #       common_ingredients.each do |i|
  #         food1.ingredients.delete(i)
  #         food2.ingredients.delete(i)
  #       end
  #       language.push([common_allergens, common_ingredients]) if common_allergens.length > 0
  #       allergen_ingredients.concat(common_ingredients)
  #     end
  #   end

  #   foods.each do |food|
  #     food.ingredients = food.ingredients.reject { |i| allergen_ingredients.include?(i) }
  #     if food.allergens.length == food.ingredients.length
  #       allergen_ingredients.concat(food.ingredients)
  #       food.ingredients = []
  #       food.allergens = []
  #       language.push([food.allergens, food.ingredients])
  #     end
  #   end
  # end

  # allergen_ingredients = 

  pp foods.map { |f| f.ingredients }.flatten.length
  # puts foods
  # pp language
  # pp allergen_ingredients
  pp allergen_ingredients.sort { |a, b| a[1] <=> b[1] }.map { |p| p[0]}.join(',')
end

solve1

def solve2
  lines = Utils.input_read(21)
end

solve2
