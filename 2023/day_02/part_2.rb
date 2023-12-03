require "../../helpers"

games = load_data("data.txt", splits: ["\n", ":", ";", ","], cast_method: :to_s).map { |a| a[1] }

ans = games.sum do |game|
  min_red = 0
  min_green = 0
  min_blue = 0

  game.each do |round|
    round.each do |dice|
      count = dice.scan(/\d+/).first.to_i
      if /red/.match?(dice)
        min_red = count if count > min_red
      elsif /blue/.match?(dice)
        min_blue = count if count > min_blue
      elsif count > min_green
        min_green = count
      end
    end
  end

  min_red * min_green * min_blue
end

puts ans
