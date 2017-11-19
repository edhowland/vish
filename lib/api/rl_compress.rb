# rl_compress.rb - method rl_compress array -  runlength compresses array of
# stringy things and others into array of compacted string objects, leaving
#  other things unchanged.
#
# Usage: new_arr = rl_compress ['a', 'b', 'c', 12, 'c', 'd', Object.new]
# returns: ['abc', 12, 'cd', object]
# Depends on array_split
def rl_compress array
  array_split(array) {|e| ! e.instance_of? String }.map {|e| e[0].instance_of?(String) ? e.join : e[0] }
end
