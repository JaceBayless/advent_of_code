require "../../helpers"

class Map
  attr_accessor :map, :distance_map

  def initialize(map:)
    @map = map
    @distance_map = build_2d_array(x: @map[0].length, y: @map.length)
  end

  def starting_position
    y = @map.index { |row| row.include?("S") }
    x = @map[y].index("S")
    [x, y]
  end

  def build_distance_map
    places_to_search = [{position: starting_position}]

    places_to_search.each do |opts|
      next_places_to_search = find_distance(**opts)&.flatten&.compact

      next_places_to_search&.each do |next_place|
        places_to_search << next_place
      end
    end
  end

  def find_furthest_distance
    @distance_map.map { _1.compact.max || 0 }.max
  end

  private

  def find_distance(position:, previous_positions: [], previous_distance: nil)
    x, y = position

    distance = previous_distance ? previous_distance + 1 : 0
    if (@distance_map[y][x] || Float::INFINITY) > distance
      @distance_map[y][x] = distance || 0
    else
      return
    end

    possible_next_positions = case @map[y][x]
    when "|" then [[x, y-1], [x, y+1]]
    when "-" then [[x-1, y], [x+1, y]]
    when "L" then [[x, y-1], [x+1, y]]
    when "J" then [[x-1, y], [x, y-1]]
    when "7" then [[x-1, y], [x, y+1]]
    when "F" then [[x, y+1], [x+1, y]]
    when "S"
      temp = []
      temp << [x, y-1] if !["S", ".", "-", "L", "J"].include?(@map[y-1][x]) && y - 1 >=0
      temp << [x+1, y] if !["S", ".", "|", "L", "F"].include?(@map[y][x+1]) && x + 1 <= @map[0].length
      temp << [x, y+1] if !["S", ".", "-", "7", "F"].include?(@map[y+1][x]) && y + 1 <= @map.length
      temp << [x-1, y] if !["S", ".", "|", "7", "J"].include?(@map[y][x-1]) && x - 1 >= 0
      temp
    end

    next_positions = possible_next_positions - previous_positions
    next_positions.map do |next_position|
      {position: next_position, previous_positions: previous_positions + [position], previous_distance: distance}
    end
  end
end

map = Map.new(map: load_data("data.txt", splits: ["\n", ""]))
map.build_distance_map
puts map.find_furthest_distance.inspect
