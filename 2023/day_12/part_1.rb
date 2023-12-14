require "../../helpers"

class DamagedSprings
  attr_accessor :springs, :rules

  def initialize(springs:, rules:)
    @springs = springs
    @rules = rules
  end

  def valid_arrangements
    count = 0
    possible_combinations.each do |combo|
      test_spring = @springs.dup

      combo.each do |i|
        test_spring[i] = "#"
      end

      (unknown_indexes - combo).each do |i|
        test_spring[i] = "."
      end

      count += 1 if arrangement_is_valid?(test_spring.join)
    end
    count
  end

  def possible_combinations
    all_possible_combinations = (0..unknown_indexes.length).flat_map do |size|
      unknown_indexes.combination(size).to_a
    end
  end

  def unknown_indexes
    @unknown_indexes ||= @springs.each_index.select{ @springs[_1] == "?" }
  end

  def arrangement_is_valid?(test_spring)
    seperated_springs = test_spring.split(".").reject(&:empty?)
    return false if seperated_springs.length != @rules.length

    @rules.each_index.all? do |i|
      seperated_springs[i].length == @rules[i]
    end
  end
end

damaged_springs = load_data("data.txt", splits: ["\n"]).map do |spring_data|
  springs, rules = spring_data.split(" ")
  DamagedSprings.new(springs: springs.split(""), rules: rules.split(",").map(&:to_i))
end

puts damaged_springs.sum(&:valid_arrangements)
