require "../../helpers"

data = load_data("data.txt").split("\n")
data = data.map do |row|
  row.gsub(/Card \d+:/, "").split(" | ").map do |numbers|
    numbers.strip.split(" ")
  end
end

ans = data.sum do |winning_nums, numbers|
  count = (winning_nums & numbers).length
  count >= 1 ? 2**(count - 1) : 0
end

puts ans
