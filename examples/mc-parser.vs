# mc-parser.vs - meta-circular parser. Takes string and grammar tree: CST
# Expects:
# load std/list.vs
defn or?(a, b) { :a or :b}
defn and?(a, b) { :a and :b}
alt=foldr(:or?, false)
seq=foldr(:and?, true)


defn mktok(s) {
  c=head(:s)
}
