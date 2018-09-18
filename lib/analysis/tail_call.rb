# tail_call.rb - class TailCall - TCO optimization

class TailCall
  include ListProc
  def run(ast)
    ast
  end
  # helper methods
  def last_child?(ast)
    !undefined?(cdr(ast)) && null?(cdr(ast))
  end
  def last_child(ast)
    if null?(ast)
      NullType.new
    elsif last_child?(ast)
      ast
    else
      last_child(cdr(ast))
    end
  end
  def lambdacall?(sexp)
    car(sexp) == :lambdacall
  end
  def lambda?(ast)
    car(ast) == :lambda
  end
  def formals(ast)
    cadr(ast)
  end
  def body(ast)
    caddr(ast)
  end

  def _run(ast)
    if null?(ast)
      NullType.new
    elsif lambda?(ast)
      list(:lambda, formals(ast), body(ast))
    elsif pair?(car(ast))
      cons(_run(car(ast) ), _run(cdr(ast)))

    else
      cons(car(ast), _run(cdr(ast)))
    end
  end
end