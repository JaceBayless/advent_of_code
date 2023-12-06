require "../../helpers"

data = load_data("data.txt", splits: ["\n\n"], cast_method: :to_s)

sources = data[0].gsub("seeds: ", "").split(" ").map(&:to_i).map { |s| [s, s] }.to_h
rule_sets = data[1..].map do |rule_set|
  rule_set.split("\n")[1..].map do |instruction|
    instruction.split(" ").map(&:to_i)
  end
end

rule_sets.each do |rule_set|
  rule_set.each do |destination, source, range|
    sources.each do |current_source, new_source|
      next if current_source != new_source
      if current_source >= source && current_source <= source + range
        sources.to_h[current_source] = destination + (current_source - source)
      end
    end
  end
  sources = sources.map { |_, ns| [ns, ns] }.to_h
end

puts sources.map(&:first).min
