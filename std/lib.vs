# std/lib.vs - Vish Standard Library functions
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
defn cadr(l) { car(cdr(:l)) }
defn cddr(l) { cdr(cdr(:l)) }
defn caddr(l) { car(cddr(:l)) }
defn cdddr(l) { cdr(cddr(:l)) }
# tail call version: use TCO=1 env var before call
  defn list_length(l) {
    defn aux(l, acc) {
      {null?(:l) && :acc} || aux(cdr(:l), 1 + :acc)
    }
    aux(:l, 0)
    }

defn undefined?(key) {
_undefined?(:key, binding())
}
# utility/collection
defn map(coll, fn) {
  empty?(:coll) && return []
  [%fn(head(:coll))] + map(tail(:coll), :fn)
}
# set up some variables
null=mknull()
version=version()
