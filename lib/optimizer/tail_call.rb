# tail_call.rb - class TailCall - TCO optimization

class TailCall
  include ListProc
  def x_run(ast)
puts 'In tail Call optimizer'
    ast
  end
  # helper methods
  def last_child?(ast)
#binding.pry
    !undefined?(cdr(ast)) && null?(cdr(ast))
  end
  def last_child(ast)
#binding.pry

    if null?(ast)
      NullType.new
    elsif last_child?(ast)
      car(ast)
    else
      last_child(cdr(ast))
    end
  end
  def lambdacall?(sexp)
#    trace("lambdacall?", sexp) { 
car(sexp) == :lambdacall 
#}
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
#    trace("tail_candidate?", ast) { 
    lambdacall?(last_child(ast)) || conditional_node?(last_child(ast))
#    }
  end
  # mktailcall sexp - return reconstituted tailcall from lambdacall
  def mktailcall(sexp)
    cons(:tailcall, cdr(sexp))
  end
  # mkcond - reconstitute logical and/or node after recursing on both legs.
  def mkcond(sexp)
    list(car(sexp), single_or_block(cadr(sexp)), single_or_block(caddr(sexp)))
  end
  def conditional?(sym)
#    trace("conditional?",sym) {
 [:logical_and, :logical_or].member? sym 
 #}
  end
  def conditional_node?(sexp)
#    trace("conditional_node?") { 
conditional?(car(sexp)) 
#}
  end
  # handle_last_child S-Expression - compute varieties of possible tail conditions
  def handle_last_child(sexp)
#binding.pry
    if lambdacall?(sexp)
      mktailcall(sexp)
    elsif conditional_node?(sexp)
      list(mkcond(sexp))
    else
      sexp
    end
  end
  # block? - true if node is a block
  def block?(sexp)
    car(sexp) == :block
  end
  # compose_statements ast - given a tail candidate block, return
  # transformed last_child
  def compose_statements(sexp)
#binding.pry
    if null?(sexp)
      NullType.new
      elsif last_child?(sexp)
#        trace('in last child')
        handle_last_child(car(sexp))
    else
      cons(_run(car(sexp)), compose_statements(cdr(sexp)))
    end
  end

  # compose_block  body - handle last child because it is in tail position
  def compose_block(body)
#binding.pry
    cons(:block, compose_statements(cdr(body)))
  end

  # single_or_block - handle leg of conditional
  def single_or_block(sexp)
#  binding.pry
    if pair?(sexp) && block?(sexp)
      compose_block(sexp)
    else
      handle_last_child(sexp)
    end
  end  
  # was def _run(ast)
  def run(ast)
#puts 'In tail Call optimizer'

    if null?(ast)
      NullType.new
    elsif lambda?(ast)
binding.pry
      if tail_candidate?(body(ast))
        list(:lambda, formals(ast), compose_block(body(ast)))
      else
        list(:lambda, formals(ast), body(ast))
      end
    elsif pair?(car(ast))
      cons(run(car(ast) ), run(cdr(ast)))
    else
      cons(car(ast), run(cdr(ast)))
    end
  end
end