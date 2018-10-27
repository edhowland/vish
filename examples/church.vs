# church.vs - Church encodings
# Booleans
defn T(a, b) { :a }
defn F(a, b) { :b }
# Curch Pairs
defn chons(a, b) { ->(f) { f(:a, :b) }}
defn char(p) { p(->(a, b) { :a }) }
# chdr - cdr: pronounced  chouder
defn chdr(p) { p(->(a, b) { :b }) }



