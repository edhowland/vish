# list.vs - Lisp - like functions in Vish
# limited to 4 internal expansions, like Racket and Chez Scheme
defn caar(l) { car(car(:l)) }
defn cdar(l) { cdr(car(:l)) }
defn cadr(l) { car(cdr(:l)) } # second
defn cddr(l) { cdr(cdr(:l)) }
defn caaar(l) { car(caar(:l)) }
defn cdaar(l) { cdr(caar(:l)) }
defn cadar(l) { car(cdar(:l)) }
defn cddar(l) { cdr(cdar(:l)) }
defn caadr(l) { car(cadr(:l)) }
defn cdadr(l) { cdr(cadr(:l)) }
defn caddr(l) { car(cddr(:l)) } # third
defn cdddr(l) { cdr(cddr(:l)) }
defn caaaar(l) { car(caaar(:l)) }
defn cdaaar(l) { cdr(caaar(:l)) }
defn cadaar(l) { car(cdaar(:l)) }
defn cddaar(l) { cdr(cdaar(:l)) }
defn caadar(l) { car(cadar(:l)) }
defn cdadar(l) { cdr(cadar(:l)) }
defn caddar(l) { car(cddar(:l)) }
defn cdddar(l) { cdr(cddar(:l)) }
defn caaadr(l) { car(caadr(:l)) }
defn cdaadr(l) { cdr(caadr(:l)) }
defn cadadr(l) { car(cdadr(:l)) }
defn cddadr(l) { cdr(cdadr(:l)) }
defn caaddr(l) { car(caddr(:l)) }
defn cdaddr(l) { cdr(caddr(:l)) }
defn cadddr(l) { car(cdddr(:l)) } # fourth
defn cddddr(l) { cdr(cdddr(:l)) }
# list functions
defn append(x, y) {
  null?(:x) && return :y
cons(car(:x), append(cdr(:x), :y))
}
# list_length(l) - tail call version
defn list_length(l) {
  defn aux(li, acc) {
    null?(:li) && return :acc
    aux(cdr(:li), :acc + 1)
  }
  aux(:l, 0)
}

