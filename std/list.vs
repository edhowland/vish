# list.vs - Lisp - like functions in Vish
defn cadr(l) { car(cdr(:l)) }
defn cddr(l) { cdr(cdr(:l)) }
defn caddr(l) { car(cddr(:l)) }
defn cdddr(l) { cdr(cddr(:l)) }
# tail call version: use TCO=1 env var before call
  defn list_length(l) {
    defn aux(l, acc) {
      {null?(:l) && :acc} || aux(cdr(:l), 1 + :acc)
    }
    aux(:l, 0)
    }
