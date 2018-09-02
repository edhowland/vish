# combo.vs - combinator functions
# identity - lambda v v - the identity function - Idiot bird
defn identity(x) { :x }
id=:identity; I=:id
# flip - reverses arguments of function, returning new function
defn flip(fn) {
  ->(y, x) { fn(:x, :y) }
}

# seq - runs 32 things in sequence
defn seq(f, s) { %f; %s }
# K : The k combinatorial or Kestral - curryied
defn kestral(v, x) {  :v }
K=curry(:kestral)
# kite - explicit version, not composed w/K I
defn kite(x, y) { :y }
# card(a, b, v) - The cardinal
defn card(p) {
  ->(v,pp) { p(:v, :pp) }
}
# M : Mockingbird
# http://dool.in/2015/04/03/a-ruby-mockingbird.html
defn M(f) { f(:f) }


