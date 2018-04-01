# append.vs - notes on implementing apped(l, r)
defn append(x, y) {
  null?(:x) && return :y
cons(car(:x), append(cdr(:x), :y))
}

