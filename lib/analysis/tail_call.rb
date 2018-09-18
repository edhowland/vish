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
      car(ast)
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
  # tail_candidate? body -  true if last_child(body) is a lambdacall or ...
  def tail_candidate?(ast)
    lambdacall?(last_child(ast))
  end

  # compose_block  body - handle last child because it is in tail position
  def compose_block(body)
    body
  end

  def _run(ast)
    if null?(ast)
      NullType.new
    elsif lambda?(ast)
      if tail_candidate?(body(ast))
        list(:lambda, formals(ast), compose_block(body(ast)))
      else
        list(:lambda, formals(ast), body(ast))
      end
    elsif pair?(car(ast))
      cons(_run(car(ast) ), _run(cdr(ast)))

    else
      cons(car(ast), _run(cdr(ast)))
    end
  end
end