# tail_call.rb - class TailCall - TCO optimization

class TailCall
  include ListProc
  include TreeUtils

  def block? x
    list?(x) && car(x) == :block
  end
  def lambdacall?(sexp)
    list?(sexp) && car(sexp) == :lambdacall
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


  def tail_candidate?(sexp)
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
      elsif  tail_candidate?(v)
        but_last(v, &l_to_t)
      elsif conditional?(v)
  #      list(car(v), xftail(cadr(v)), xftail(caddr(v)))
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


# map_tree_for tree, keywords w/lambdas for various node types. Like visit_tree

def map_tree_for(tree, **nf)
  map_inner_tree(tree) do |node|
    if list?(node) && nf[car(node)]
      nf[car(node)].call(node)
    else
      node
    end
  end
end


  def run(ast)
    map_tree_with(ast, lambda: ->(node) { xftail(node) })
#    xftail(ast)
  end
end
