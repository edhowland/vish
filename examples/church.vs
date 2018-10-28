# church.vs - Church encodings
# Booleans
defn T(a, b) { :a }
defn F(a, b) { :b }
# Curch Pairs
defn chons(a, b) { ->(f) { f(:a, :b) }}
defn char(p) { p(->(a, b) { :a }) }
# chdr - cdr: pronounced  chouder
defn chdr(p) { p(->(a, b) { :b }) }
# Putting all this to work:
# Ternary expressions: p ? t : f; or if/then/else
# Given a p: predicate, a Curch boolean, either T or F above; Evaluate the 
# c: consequent or the a: alternate
defn ternary(p, c, a) { p(:c, :a) }
# Test code:
# defn eq0(x) { {zero?(:x) && :T} || :F}
# call it
# ternary(eq0(0), 'is zero', 'not zero')




