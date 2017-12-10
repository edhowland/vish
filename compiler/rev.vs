# rev.vs - reverses linked list
l=list(1,2,3,4,5)
defn rev(l) { :l == list() && return :l; list(rev(tail(:l)), head(:l)) }
rev(:l)
