require "../../helpers"

class Map
  def initialize(map)
    @map = map
  end

  def horizontal_line_of_reflection
    (map_height - 1).times do |i|
      above = @map[0..i]
      below = @map[i+1..]

      match_length = [above.length, below.length].min

      return i + 1 if above.last(match_length) == below.first(match_length).reverse
    end
    nil
  end

  def vertical_line_of_reflection
    flipped_map = @map.transpose

    (map_width - 1).times do |i|
      above = flipped_map[0..i]
      below = flipped_map[i+1..]

      match_length = [above.length, below.length].min

      return i + 1 if above.last(match_length) == below.first(match_length).reverse
    end
    nil
  end

  def map_height
    @map.length
  end

  def map_width
    @map[0].length
  end
end

maps = load_data("data.txt", splits: ["\n\n", "\n", ""]).map{ |m| Map.new(m) }

ans = maps.sum do |map|
  map.vertical_line_of_reflection || (map.horizontal_line_of_reflection * 100)
end

puts ans
