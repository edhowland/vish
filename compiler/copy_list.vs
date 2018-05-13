# copy_list.vs - copy a list, recursivly
defn cl(l) {
null?(:l) && return :null
list?(car(:l)) && return cons(car(:l), cl(cdr(:l)))
cons(car(:l), cl(cdr(:l)))
}


