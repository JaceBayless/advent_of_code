require "../../helpers"

class Map
  attr_accessor :map, :enclosure_map

  def initialize(map:)
    map.map! do |row|
      row.unshift(".")
      row << "."
      row
    end

    filler_row = ["."] * map[0].length
    map_with_border = [filler_row, *map, filler_row]

    @map = map_with_border
    @enclosure_map = build_2d_array(x: @map[0].length, y: @map.length)
  end

  def build_enclosure_map
    current_position = starting_position
    previous_position = nil
    while current_position != starting_position || previous_position.nil?
      current_position, previous_position = mark_and_move(position: current_position, previous_position: previous_position)
    end
    fill_in_blanks
    invert_map if map_inverted?
  end

  def enclosed_tiles_count
    @enclosure_map.sum do |row|
      row.count(1)
    end
  end

  private

  def starting_position
    y = @map.index { |row| row.include?("S") }
    x = @map[y].index("S")
    [x, y]
  end

  def mark_and_move(position:, previous_position:)
    x, y = position
    prev_x, prev_y = previous_position

    @enclosure_map[y][x] = "."

    possible_next_positions = nil
    case @map[y][x]
    when "|"
      possible_next_positions = [[x, y-1], [x, y+1]]

      if prev_y < y
        @enclosure_map[y][x-1] ||= 1
        @enclosure_map[y][x+1] ||= 0
      else
        @enclosure_map[y][x-1] ||= 0
        @enclosure_map[y][x+1] ||= 1
      end
    when "-"
      possible_next_positions = [[x-1, y], [x+1, y]]

      if prev_x < x
        @enclosure_map[y-1][x] ||= 0
        @enclosure_map[y+1][x] ||= 1
      else
        @enclosure_map[y-1][x] ||= 1
        @enclosure_map[y+1][x] ||= 0
      end
    when "L"
      possible_next_positions = [[x, y-1], [x+1, y]]

      if prev_y < y
        @enclosure_map[y][x-1] ||= 1
        @enclosure_map[y+1][x-1] ||= 1
        @enclosure_map[y+1][x] ||= 1
        @enclosure_map[y-1][x+1] ||= 0
      else
        @enclosure_map[y][x-1] ||= 0
        @enclosure_map[y+1][x-1] ||= 0
        @enclosure_map[y+1][x] ||= 0
        @enclosure_map[y-1][x+1] ||= 1
      end
    when "J"
      possible_next_positions = [[x-1, y], [x, y-1]]

      if prev_y < y
        @enclosure_map[y][x+1] ||= 0
        @enclosure_map[y+1][x+1] ||= 0
        @enclosure_map[y+1][x] ||= 0
        @enclosure_map[y-1][x-1] ||= 1
      else
        @enclosure_map[y][x+1] ||= 1
        @enclosure_map[y+1][x+1] ||= 1
        @enclosure_map[y+1][x] ||= 1
        @enclosure_map[y-1][x-1] ||= 0
      end
    when "7"
      possible_next_positions = [[x-1, y], [x, y+1]]

      if prev_y > y
        @enclosure_map[y-1][x] ||= 1
        @enclosure_map[y-1][x+1] ||= 1
        @enclosure_map[y][x+1] ||= 1
        @enclosure_map[y+1][x-1] ||= 0
      else
        @enclosure_map[y-1][x] ||= 0
        @enclosure_map[y-1][x+1] ||= 0
        @enclosure_map[y][x+1] ||= 0
        @enclosure_map[y+1][x-1] ||= 1
      end
    when "F"
      possible_next_positions = [[x, y+1], [x+1, y]]

      if prev_y > y
        @enclosure_map[y-1][x] ||= 0
        @enclosure_map[y-1][x-1] ||= 0
        @enclosure_map[y][x-1] ||= 0
        @enclosure_map[y+1][x+1] ||= 1
      else
        @enclosure_map[y-1][x] ||= 1
        @enclosure_map[y-1][x-1] ||= 1
        @enclosure_map[y][x-1] ||= 1
        @enclosure_map[y+1][x+1] ||= 0
      end
    when "S"
      possible_next_positions = []
      possible_next_positions << [x, y-1] if !["S", ".", "-", "L", "J"].include?(@map[y-1][x])
      possible_next_positions << [x+1, y] if !["S", ".", "|", "L", "F"].include?(@map[y][x+1])
      possible_next_positions << [x, y+1] if !["S", ".", "-", "7", "F"].include?(@map[y+1][x])
      possible_next_positions << [x-1, y] if !["S", ".", "|", "7", "J"].include?(@map[y][x-1])
    end

    next_position = (possible_next_positions - [previous_position])[0]
    [next_position, position]
  end

  def fill_in_blanks
    while has_nil_values?
      @enclosure_map.length.times do |y|
        @enclosure_map[y].length.times do |x|
          next if @enclosure_map[y][x] != nil
          touched_value = nil
          (-1..1).each do |test_y|
            (-1..1).each do |test_x|
              if y + test_y >= 0 && y + test_y <= @map.length && x + test_x >= 0 && x + test_x <= @map[y].length
                touched_value ||= @enclosure_map[y + test_y][x + test_x]
              end
            end
          end
          @enclosure_map[y][x] = touched_value
        end
      end
    end
  end

  def has_nil_values?
    @enclosure_map.any? { _1.any?(nil) }
  end

  def invert_map
    @enclosure_map.length.times do |y|
      @enclosure_map[y].length.times do |x|
        current_value = @enclosure_map[y][x]
        next if current_value == "."
        @enclosure_map[y][x] = 1 if current_value == 0
        @enclosure_map[y][x] = 0 if current_value == 1
      end
    end
  end

  def map_inverted?
    @enclosure_map[0][0] == 1
  end
end

map = Map.new(map: load_data("data.txt", splits: ["\n", ""]))
map.build_enclosure_map
puts map.enclosed_tiles_count
