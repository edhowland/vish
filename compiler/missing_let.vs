# missing_let.vs - loops over closure creation
# TODO: Make this work first. Has some unknown bugs
# First lets some Lisp functions
defn cons(x, y) { mkpair(:x, :y) }
defn car(s) { xmit(:s, key:) }
defn cdr(t) { xmit(:t, value:) }
defn null?(s) { :s == [] }
i=0
set=[]
loop {
  :i == 10 && break
  set=cons(:i, :set)
i=:i + 1
}
print(:set)

