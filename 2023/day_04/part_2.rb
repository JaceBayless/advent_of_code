require "../../helpers"

data = load_data("data.txt").split("\n")

cards_counter = []
data.length.times do |i|
  cards_counter << [i + 1, 1]
end
cards_counter = cards_counter.to_h

data = data.map do |row|
  row.gsub(/Card \d+:/, "").split(" | ").map do |numbers|
    numbers.strip.split(" ")
  end
end

data.each_with_index do |game, index|
  index += 1
  winning_nums, numbers = game
  tickets_won = (winning_nums & numbers).length

  (1..tickets_won).each do |offset|
    cards_counter[index + offset] += 1 * cards_counter[index]
  end
end

puts cards_counter.map { |c| c[1] }.sum
