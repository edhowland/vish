# array_join.rb - method array_join array, string_symbol - like .join buts
#  returns new array. Like Array.join, buts justs adds separator between 
#elements and returns new array.

def array_join(array, sep)
  result = array.map {|e| [e, sep] }.flatten
  result.pop
  result
  end
  