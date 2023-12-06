require "../../helpers"

class RangeNode
  attr_accessor :range_start, :range_end, :already_mutated

  def initialize(range_start:, range_end:, already_mutated: false)
    @range_start = range_start
    @range_end = range_end
    @already_mutated = already_mutated
  end

  def adjust_for_range(offset:, range_start:, range_end:)
    # new range is fully inside this range
    if range_start > @range_start && range_end < @range_end
      [
        RangeNode.new(range_start: @range_start, range_end: range_start - 1),
        RangeNode.new(range_start: range_start + offset, range_end: range_end + offset, already_mutated: true),
        RangeNode.new(range_start: range_end + 1, range_end: @range_end)
      ]
    # new range is fully outside this range
    elsif range_start <= @range_start && range_end >= @range_end
      [
        RangeNode.new(range_start: @range_start + offset, range_end: @range_end + offset, already_mutated: true)
      ]
    # overhang on the right
    elsif range_start >= @range_start && range_start <= @range_end
      [
        RangeNode.new(range_start: @range_start, range_end: range_start - 1),
        RangeNode.new(range_start: range_start + offset, range_end: @range_end + offset, already_mutated: true)
      ]
    # overhang on the left
    elsif range_end >= @range_start && range_end <= @range_end
      [
        RangeNode.new(range_start: @range_start + offset, range_end: range_end + offset, already_mutated: true),
        RangeNode.new(range_start: range_end + 1, range_end: @range_end)
      ]
    else
      self
    end
  end

  def mark_unmutated
    @already_mutated = false
  end
end

range_nodes = []
data = load_data("data.txt", splits: ["\n\n"], cast_method: :to_s)

sources = data[0].gsub("seeds: ", "").split(" ").map(&:to_i)
range_nodes = sources.each_slice(2).map do |start, range|
  RangeNode.new(range_start: start, range_end: start + range - 1)
end

data[1..].map do |rule_set|
  rule_set.split("\n")[1..].map do |instruction|
    destination, source, range = instruction.split(" ").map(&:to_i)
    range_nodes.map! do |range_node|
      if range_node.already_mutated
        range_node
      else
        range_node.adjust_for_range(offset: destination - source, range_start: source, range_end: source + range - 1)
      end
    end
    range_nodes.flatten!
  end
  range_nodes.each(&:mark_unmutated)
end

puts range_nodes.map(&:range_start).min
