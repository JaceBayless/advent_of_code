require "../../helpers"

class EngineSchematicManager
  attr_accessor :schematic, :found_numbers, :found_cordinates

  def initialize(schematic)
    @schematic = schematic
    @found_numbers = []
    @found_cordinates = []
  end

  def part_numbers
    @schematic.length.times do |y|
      @schematic[y].length.times do |x|
        if !@schematic[y][x].match(/\d|\./)
          (-1..1).each do |check_y|
            (-1..1).each do |check_x|
              if @schematic[y + check_y][x + check_x].match?(/\d/)
                find_and_mark_number(x + check_x, y + check_y)
              end
            end
          end
        end
      end
    end

    @found_numbers
  end

  private_class_method

  def find_and_mark_number(x, y)
    return if @found_cordinates.include?([x, y])

    left_bound = x
    right_bound = x

    while @schematic[y][left_bound] =~ /\d/
      left_bound -= 1
    end
    while @schematic[y][right_bound] =~ /\d/
      right_bound += 1
    end

    number_range = ((left_bound + 1)..(right_bound - 1))

    @found_numbers << @schematic[y][number_range].join.to_i
    number_range.each do |x_to_mark|
      @found_cordinates << [x_to_mark, y]
    end
  end
end

data = load_data("data.txt", splits: ["\n", ""], cast_method: :to_s)
puts EngineSchematicManager.new(data).part_numbers.sum
