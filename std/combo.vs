# combo.vs - combinator functions
# B, Bluebird - compose
defn bluebird(f, g, x) {
  g(:x) | %f
}
B=:bluebird;compose=:B
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
# This is also the Church true function
defn kestral(v, x) {  :v }
K=curry(:kestral); True=:K
# kite - explicit version, not composed w/K I
#defn kite(x, y) { :y }
# card(a, b, v) - The cardinal
defn cardinal(fn, x, y) { fn(:y, :x) }
C=curry(:cardinal)
# The kite is also the Church false function
kite=C(:K);KI=:kite;False=:KI
# Not reverses its boolean expression
defn Not(b) { b(:False, :True) }
defn card(p) {
  ->(v,pp) { p(:v, :pp) }
}
# M : Mockingbird
# http://dool.in/2015/04/03/a-ruby-mockingbird.html
defn M(f) { f(:f) }


