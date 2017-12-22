# closure.vs - test compile of closure stuff
defn baz(p) {
  ->(y) { :y * :p }
}
m9=baz(9)
m4=baz(4)
result=%m9(2) + %m4(3)
:result == 30
