require "../../helpers"

space = load_data("data.txt", splits: ["\n", ""])

space.map! do |row|
  if row.all?(".")
    [row, row]
  else
    [row]
  end
end.flatten!(1)

space = space.transpose
space.map! do |row|
  if row.all?(".")
    [row, row]
  else
    [row]
  end
end.flatten!(1)

space = space.transpose

count = 0
markers = {}

space.length.times do |i|
  space[i].length.times do |j|
    if space[i][j] != "."
      count += 1
      space[i][j] = count
      markers[count] = [j, i]
    end
  end
end

combos = (1..count).to_a.combination(2).to_a

ans = combos.sum do |a, b|
  ax, ay = markers[a]
  bx, by = markers[b]

  (by - ay).abs + (bx - ax).abs
end

puts ans
