# lisp.vs - pretend we are scheme/lisp:
defn cons(k, v) {
  ->(s) { (:s == 1) && return :k; :v }
}
defn car(l) { %l(1) }
defn cdr(l) { %l(2) }

# fancy null, just return self
defn null() { :null }
defn null?(c) { :c == :null }
