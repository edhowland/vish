# std/lib.vs - Vish Standard Library functions
# internal identity function: used for continuations
# mkarr - creates object for use of  in object construction
# Usage: obj=mkarr(foo:, 2)
defn mkattr(k,v) {
  s=mksym("%{:k}!")
  mkobject(mkpair(:k, ->() { :v }), mkpair(:s, ->(x) { v=:x; :v }))
}
defn keys(obj) { xmit(:obj, keys:) }
defn values(obj) { xmit(:obj, values:) }

# list helpers
defn car(l) { key(:l) }
defn cdr(l) { value(:l) }

defn undefined?(key) {
_undefined?(:key, binding())
}
# utility/collection
defn map(coll, fn) {
  empty?(:coll) && return []
  [%fn(head(:coll))] + map(tail(:coll), :fn)
}
# Continuation stuff
## REALLY do not call this:
__frames=_mklambda([], [frame:], gensym())
defn unwind_one(s) {
  xmit(:s, pop:)
  :s
}
# Bug: Must get the outer frame, not the __frames frame itself
defn callcc(l) {
  l(_mkcontinuation(unwind_one(__frames()), :callcc))
}
# set up some variables
null=mknull()
version=version()
