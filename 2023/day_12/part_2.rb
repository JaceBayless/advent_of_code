require "../../helpers"

def valid_arrangements(spring_set:, rules:, current_group_length: 0, data: {})
  key = [spring_set, rules, current_group_length]

  return data[key] if data[key]

  if spring_set == ""
    if (rules.empty? && current_group_length == 0) || (rules.length == 1 && rules[0] == current_group_length)
      return 1
    else
      return 0
    end
  end

  return 0 if rules.any? && current_group_length > rules[0]

  if spring_set[0] == "?"
    temp = [
      valid_arrangements(spring_set: "##{spring_set[1..]}", rules: rules, current_group_length: current_group_length, data: data),
      valid_arrangements(spring_set: ".#{spring_set[1..]}", rules: rules, current_group_length: current_group_length, data: data)
    ]

    return data[key] = temp.sum
  elsif spring_set[0] == "#"
    return data[key] = valid_arrangements(spring_set: spring_set[1..], rules: rules, current_group_length: current_group_length + 1, data: data)
  else
    if current_group_length == 0
      return data[key] = valid_arrangements(spring_set: spring_set[1..], rules: rules, current_group_length: 0, data: data)
    elsif current_group_length == rules[0]
      return data[key] = valid_arrangements(spring_set: spring_set[1..], rules: rules[1..], current_group_length: 0, data: data)
    else
      return 0
    end
  end
end

data = load_data("data.txt", splits: ["\n"]).map do |d|
  temp = d.split(" ")
  temp[0] = ([temp[0]] * 5).join("?")
  temp[1] = temp[1].split(",").map(&:to_i) * 5
  temp
end

puts data.sum { |spring_set, rules| valid_arrangements(spring_set: spring_set, rules: rules) }
