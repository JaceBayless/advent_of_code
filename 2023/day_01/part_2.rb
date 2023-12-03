require "../../helpers"

data = load_data("data.txt", splits: ["\n"], cast_method: :to_s)

ans = 0
data.each do |line|
  numbers = []
  line.length.times do |i|
    x = line[i..]
    numbers << x[0].to_i if x[0].to_i != 0
    numbers << 1 if x.start_with?("one")
    numbers << 2 if x.start_with?("two")
    numbers << 3 if x.start_with?("three")
    numbers << 4 if x.start_with?("four")
    numbers << 5 if x.start_with?("five")
    numbers << 6 if x.start_with?("six")
    numbers << 7 if x.start_with?("seven")
    numbers << 8 if x.start_with?("eight")
    numbers << 9 if x.start_with?("nine")
  end
  ans += numbers.first * 10 + numbers.last
end
puts ans
