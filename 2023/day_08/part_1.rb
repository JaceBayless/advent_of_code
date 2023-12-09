require "../../helpers"

instructions, mapping = load_data("data.txt", splits: ["\n\n"], cast_method: :to_s)

mapping = mapping.gsub(/\(|\)/, "").split("\n").map do |node|
  node = node.split(" = ")
  node[1] = node[1].split(", ")
  node
end.to_h

steps = 0
current_position = "AAA"
loop do
  instructions.chars.each do |instruction|
    puts current_position
    current_position = mapping[current_position][instruction == "L" ? 0 : 1]
    steps += 1

    break if current_position == "ZZZ"
  end
  break if current_position == "ZZZ"
end

puts steps
