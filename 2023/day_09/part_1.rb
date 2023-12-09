require "../../helpers"

def next_value_in_sequence(sequence)
  sub_sequence = sequence.each_cons(2).map do |a, b|
    b - a
  end

  modifier = if sub_sequence.uniq.length == 1
    sub_sequence.first
  else
    next_value_in_sequence(sub_sequence)
  end

  sequence.last + modifier
end

sequences = load_data("data.txt", splits: ["\n", " "], cast_method: :to_i)

puts sequences.map { next_value_in_sequence(_1) }.sum
