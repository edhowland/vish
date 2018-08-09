# gen.vs - test for callcc with generator
kk=9
defn gen() {
  x=0
init=false
loop {
  callcc(->(k) {kk=:k})
! :init && return {init=true}
  x=:x + 1
return :x
  }
}
