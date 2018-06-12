# compose.vs -  Given 2 functions of one arg, return new fn combining them.
defn compose(f, g) {
  ->(x) { g(:x) | f() }
}
# now lets try it out
defn incr(a) { :a + 1 }
defn doubler(x) { :x * 2 }
two_times_plus_one=compose(:incr, :doubler)
# now lets call it
%two_times_plus_one(4)
# should be 9



