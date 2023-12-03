require "../../helpers"

data = load_data("data.txt", splits: ["\n"], cast_method: :to_s)

ans = 0
data.each do |line|
  numbers = line.scan(/\d/)
  first = numbers.first
  last = numbers.last
  ans += "#{first}#{last}".to_i
end
puts ans
