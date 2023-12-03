require "../../helpers"

games = load_data("data.txt", splits: ["\n", ":", ";", ","], cast_method: :to_s).map { |a| a[1] }

MAX_RED = 12
MAX_GREEN = 13
MAX_BLUE = 14

index = 0
ans = games.sum do |game|
  index += 1

  possible = game.all? do |round|
    round.all? do |dice|
      count = dice.scan(/\d+/).first.to_i
      count <= if /red/.match?(dice)
        MAX_RED
      elsif /blue/.match?(dice)
        MAX_BLUE
      else
        MAX_GREEN
      end
    end
  end

  possible ? index : 0
end

puts ans
