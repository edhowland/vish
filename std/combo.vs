# combo.vs - combinator functions
# identity - lambda v v - the identity function - Idiot bird
defn identity(x) { :x }
id=:identity
# flip - reverses arguments of function, returning new function
defn flip(fn) {
  ->(y, x) { fn(:x, :y) }
}

# seq - runs 32 things in sequence
defn seq(f, s) { %f; %s }
# k : The k combinatorial or Kestral
defn K(v) { ->(z) { :v } }
# card(a, b, v) - The cardinal
defn card(p) {
  ->(v,pp) { p(:v, :pp) }
}
# M : Mockingbird
defn M(f) { f(:f) }


