# list_proc.rb - module ListProc - Lisp - like list procedures

module ListProc
    def length(sexp, result=0)
    return result if null?(sexp)
    1 + length(cdr(sexp), result)
  end
  def car(x)
    x.key
  end
  def cdr x
    x.value
  end
def cadr(x)
  car(cdr(x))
end
  def caddr(x)
    car(cadr(x))
  end
#
end