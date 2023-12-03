require "../../helpers"

class EngineSchematicManager
  attr_accessor :schematic, :ratios

  def initialize(schematic)
    @schematic = schematic
    @ratios = []
  end

  def part_ratios
    @schematic.length.times do |y|
      @schematic[y].length.times do |x|
        if /\*/.match?(@schematic[y][x])
          numbers_found = 0
          number_positions = []
          (-1..1).each do |check_y|
            previous_was_number = false
            (-1..1).each do |check_x|
              if @schematic[y + check_y][x + check_x].match?(/\d/)
                if !previous_was_number
                  numbers_found += 1
                  number_positions << [x + check_x, y + check_y]
                end
                previous_was_number = true
              else
                previous_was_number = false
              end
            end
          end

          if numbers_found == 2
            @ratios << number_positions.map { |numbers| find_number(*numbers) }.inject(:*)
          end
        end
      end
    end

    @ratios
  end

  private_class_method

  def find_number(x, y)
    left_bound = x
    right_bound = x

    while @schematic[y][left_bound] =~ /\d/
      left_bound -= 1
    end
    while @schematic[y][right_bound] =~ /\d/
      right_bound += 1
    end

    number_range = ((left_bound + 1)..(right_bound - 1))
    @schematic[y][number_range].join.to_i
  end
end

data = load_data("data.txt", splits: ["\n", ""], cast_method: :to_s)
puts EngineSchematicManager.new(data).part_ratios.sum
