def recursive_split(data, splits: [], cast_method: :to_s)
  return data.send(cast_method) if splits.empty?
  data.split(splits.first).map { |d| recursive_split(d, splits: splits[1..], cast_method:) }
end

def load_data(file_name, ...)
  recursive_split(File.read(file_name).strip, ...)
end

def build_2d_array(x:, y:, default_content: nil)
  Array.new(y) { Array.new(x) { default_content.dup } }
end
