# array_split.rb - method array_split array - splits array into  sub-arrays
# based on criteria when block is true

def array_split array, &blk
  array.each_with_object([[]]) { |e,o| blk[e] ? (o << [e]; o << []) : o[-1] << e }.reject(&:empty?)
end
