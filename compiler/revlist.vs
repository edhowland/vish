# revlist.vs - reverse a list
##( define ( reverse1 l ) ( if ( null? l ) nil ( append ( reverse1 ( cdr l )) ( list ( car l ))) ) ) 
defn rev(l) {
  null?(:l) && return Null
  append(rev(cdr(:l)), list(car(:l)))
}

