# tail_call.rb - class TailCall - TCO optimization

class TailCall
  def run(ast)
    ast
  end

  def _run(ast)
    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(_run(car(ast) ), _run(cdr(ast)))

    else
      cons(car(ast), _run(cdr(ast)))
    end
  end
end