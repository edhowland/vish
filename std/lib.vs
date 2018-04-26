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

defn list_length(l) {
  null?(:l) && return 0
  1 + list_length(cdr(:l))
}
# set up some variables
null=mknull()
version=version()
# Can check the current dir with %pwd
pwd=->() { pwd() }
