require "../../helpers"

instructions, mapping_rules = load_data("data.txt", splits: ["\n\n"], cast_method: :to_s)

class Node
  attr_accessor :current_position, :loop_length

  def initialize(starting_position:)
    @current_position = "#{starting_position}"
  end

  def find_loop(instructions:, mapping_rules:)
    previous_positions = []
    while true do
      instructions.chars.each_with_index do |instruction, index|
        previous_positions << @current_position
        @current_position = mapping_rules[@current_position][instruction == "L" ? 0 : 1]

        if current_position.end_with?("Z")
          @loop_length = previous_positions.length
          return
        end
      end
    end
  end
end

mapping_rules = mapping_rules.gsub(/\(|\)/, "").split("\n").map do |node|
  node = node.split(" = ")
  node[1] = node[1].split(", ")
  node
end.to_h

nodes = mapping_rules.select { _1.end_with?("A") }.map do |k, _|
  node = Node.new(starting_position: k)
  node.find_loop(instructions: instructions, mapping_rules: mapping_rules)
  node
end

puts nodes.map(&:loop_length).inject(&:lcm)
