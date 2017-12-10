# each.vs - The each method. Takes a list and iterates the provided  function
# over it
defn each(l, fn) { :l == list() && return true; %fn(head(:l)); each(tail(:l), :fn) }
li=list(1,2,3,4)
each(:li, ->(x) { print(:x) })

