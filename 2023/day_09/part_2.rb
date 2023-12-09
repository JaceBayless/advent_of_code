require "../../helpers"

def previous_value_of_sequence(sequence)
  sub_sequence = sequence.each_cons(2).map do |a, b|
    b - a
  end

  modifier = if sub_sequence.uniq.length == 1
    sub_sequence.first
  else
    previous_value_of_sequence(sub_sequence)
  end

  sequence.first - modifier
end

sequences = load_data("data.txt", splits: ["\n", " "], cast_method: :to_i)

puts sequences.map { previous_value_of_sequence(_1) }.sum
