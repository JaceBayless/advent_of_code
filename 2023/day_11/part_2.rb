require "../../helpers"

space = load_data("data.txt", splits: ["\n", ""])

rows_to_duplicate = []

space.length.times do |i|
  rows_to_duplicate << i if space[i].all?(".")
end

columns_to_duplicate = []

space[0].length.times do |i|
  columns_to_duplicate << i if space.map{ _1[i] }.all?(".")
end

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

  base_distance = (by - ay).abs + (bx - ax).abs
  duplicate_rows = (((ay..by).to_a + (by..ay).to_a) & rows_to_duplicate).length * 999_999
  duplicate_columns = (((ax..bx).to_a + (bx..ax).to_a) & columns_to_duplicate).length * 999_999

  base_distance + duplicate_rows + duplicate_columns
end

puts ans
