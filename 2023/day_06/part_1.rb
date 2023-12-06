require "../../helpers"

class Race
  attr_accessor :time_ms, :record_distance

  def initialize(time_ms:, record_distance:)
    @time_ms = time_ms
    @record_distance = record_distance
  end

  def possible_distances
    (0..@time_ms).map do |time|
      speed = time
      running_duration = @time_ms - time
      speed * running_duration
    end
  end

  def winnable_times
    possible_distances.select { _1 > @record_distance }
  end

  def number_of_winnable_times
    winnable_times.length
  end
end

data = load_data("data.txt", splits: ["\n", ":"], cast_method: :to_s).map { _1[1].split(" ").map(&:to_i) }

races = []
data[0].length.times do |i|
  races << Race.new(time_ms: data[0][i], record_distance: data[1][i])
end

puts races.map(&:number_of_winnable_times).inject(:*)
