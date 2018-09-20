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
    lambdacall?(last_child(ast)) || conditional?(last_child(ast))
  end
  # mktailcall sexp - return reconstituted tailcall from lambdacall
  def mktailcall(sexp)
    cons(:tailcall, cdr(sexp))
  end
  def conditional?(sym)
    trace('conditional?') { [:logical_and, :logical_or].member? sym }
  end
  # handle_last_child S-Expression - compute varieties of possible tail conditions
  def handle_last_child(sexp)
  binding.pry
    if lambdacall?(car(sexp))
      mktailcall(sexp)
    elsif conditional?(caar(sexp))
      sexp
    else
      sexp
    end
  end
  # compose_statements ast - given a tail_candidate block, return
  # transformed last_child
  def compose_statements(sexp)
    if null?(sexp)
      NullType.new
      elsif last_child?(sexp)
        handle_last_child(sexp)
    else
      cons(car(sexp), compose_statements(cdr(sexp)))
    end
  end

  # compose_block  body - handle last child because it is in tail position
  def compose_block(body)
    cons(:block, compose_statements(cdr(body)))
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