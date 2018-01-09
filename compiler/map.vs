# map.vs - implements map method over list applying fn for each item, returning
# new list
defn map(li, fn) { :li == list() && return list(); list(%fn(head(:li)), map(tail(:li), :fn)) }
map([1,2,3,4], ->(x) { :x * 2 })
