# apply.rb - class Apply - From Lisp 1.5 manual

class Apply
  # _pairs(sexp, value, result=NullType.new
  def _pairs(_list, values) #, result=NullType.new)
    if null?(_list)
      return NullType.new
    end
    Builtins.cons(Builtins.cons(car(_list), car(values)), _pairs(cdr(_list), cdr(values)))
  end
  # pairlist - given a list of identifiers 
  # and another list of values : 
  # returns a list of pairs. Similar to Ruby array.zip method
  def pairlist(idents, values)
    
  end
end
