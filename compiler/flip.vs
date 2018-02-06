#  flip.vs - flip(fn) takes fn with 2 vars, returns fn with args reversed
defn flip(fn) {
  ->(a, b) { %fn(:b, :a) }
}
fn1=->(a,b) { :a ** :b }
fn2=flip(:fn1)
print(%fn1(2,3))
%fn2(2,3)
