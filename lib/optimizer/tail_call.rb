# tail_call.rb - class TailCall - TCO optimization

class TailCall
  include ListProc
  include TreeUtils

  # util methods
  def parmlist_of_lambda(lmb)
    cadr(lmb)
  end
  def block_of_lambda(sexp)
    caddr(sexp)
  end
  def mklambda(parms, block)
    list(:lambda, parms, block)
  end
  # _run ast, - Eventually run
  def _run(ast)
    map_tree_with ast, lambda: ->(lmb) {
      mklambda(parmlist_of_lambda(lmb), handle_block(block_of_lambda(lmb)))
    }
  end

  # predicate methods
  def block? x
    list?(x) && car(x) == :block
  end
  def lambdacall?(sexp)
    list?(sexp) && car(sexp) == :lambdacall
  end

  # re-composer methods
  def lambdacall_to_tailcall(x)
        cons(:tailcall, cdr(x))
  end

  # expression_or_block(sexp) - Handle the left side of conditional  expression
  def expression_or_block(sexp)
    if block?(sexp)
      handle_block(sexp)
    else
      sexp
    end
  end

  # taily - TODO: MUST Rename this badly named function
  # handles the tail of a block, in a block of a lambda, for example
  def taily(sexp)
    if lambdacall?(sexp)
      lambdacall_to_tailcall(sexp)
    elsif conditional?(sexp)
        left = cadr(sexp); right = caddr(sexp)
        left = expression_or_block(left)
        if lambdacall?(right)
          right = lambdacall_to_tailcall(right)
        else
          right = expression_or_block(right)
        end
        list(car(sexp), left, right)
    elsif block?(sexp)
      handle_block(sexp)
    else
      sexp
    end
  end

  def handle_block(block)
    but_last(block) {|tail| taily(tail) }
  end

  def fin lst
    if null?(lst)
      NullType.new
    elsif null?(cdr(lst))
      car(lst)
    else
      fin(cdr(lst))
    end
  end


  def block_has_tail_lambda?(sexp)
    block?(sexp) && lambdacall?(fin(sexp))
  end
  def return?(sexp)
    list?(sexp) && car(sexp) == :_return
  end
  def return_via_lambdacall?(sexp)
    list?(sexp) && return?(sexp) && lambdacall?(cdr(sexp))
  end

  def mkl
    ->(x) {
    cons(:tailcall, cdr(x))
    }
  end

  def conditional?(sexp)
    list?(sexp) && [:logical_or, :logical_and].member?(car(sexp))
  end

# but_last - return all elements of list except the last
def but_last lst, &blk
  if null?(lst)
    NullType.new
  elsif null?(cdr(lst))
    block_given? ? list(blk.call(car(lst))) : NullType.new
  else
    cons(car(lst), but_last(cdr(lst), &blk))
  end
end


  def xftail(ast)
    l_to_t = mkl
    map_inner_tree(ast) do |v|
      if return_via_lambdacall?(v)
        cons(car(v), l_to_t.call(cdr(v)))
      elsif  block_has_tail_lambda?(v)
        but_last(v, &l_to_t)
      elsif conditional?(v)
        left = cadr(v); right = caddr(v)
        if lambdacall?(right)
          right = l_to_t.call(right)
        else
          right = xftail(right)
        end
        list(car(v), xftail(left), right)
      else
        v
      end
    end
  end




  def run(ast)
    map_tree_with(ast, lambda: ->(node) { xftail(node) })
#    xftail(ast)
  end
end
