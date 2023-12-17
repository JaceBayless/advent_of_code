require "../../helpers"

class Map
  def initialize(map)
    @map = map
  end

  def horizontal_line_of_reflection
    (@map.length - 1).times do |i|
      above = @map[0..i]
      below = @map[i+1..]

      match_length = [above.length, below.length].min

      return i + 1 if total_not_matching_spots(above.last(match_length), below.first(match_length).reverse) == 1
    end
    nil
  end

  def vertical_line_of_reflection
    flipped_map = @map.transpose

    (flipped_map.length - 1).times do |i|
      above = flipped_map[0..i]
      below = flipped_map[i+1..]

      match_length = [above.length, below.length].min

      return i + 1 if total_not_matching_spots(above.last(match_length), below.first(match_length).reverse) == 1
    end
    nil
  end

  def total_not_matching_spots(part_1, part_2)
    height = part_1.length
    width = part_1[0].length

    not_matching_spots = 0
    height.times do |y|
      width.times do |x|
        not_matching_spots += 1 if part_1[y][x] != part_2[y][x]
      end
    end
    not_matching_spots
  end
end

maps = load_data("data.txt", splits: ["\n\n", "\n", ""]).map{ |m| Map.new(m) }

ans = maps.sum do |map|
  map.vertical_line_of_reflection || (map.horizontal_line_of_reflection * 100)
end

puts ans
