# array_select.rb - method array_select(arr, &blk) - selects on items or indexes

def array_select(arr, &blk)
  arr.each_with_index.select(&blk).map {|e, i| e }
end