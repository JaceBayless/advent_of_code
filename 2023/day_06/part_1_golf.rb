p File.read("data.txt").split("\n").map{_1.scan(/\d+/).map(&:to_i)}.transpose.map{_1-2*((_1-Math.sqrt(_1**2-4*_2))/2).next_float.ceil+1}.inject(:*)
