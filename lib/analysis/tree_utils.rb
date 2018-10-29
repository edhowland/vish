# tre_utils.rb - Module TreeUtils : like copy_tree

# TreeUtils - Used in optimizers within VishCompiler
module TreeUtils
  include ListProc

  def copy_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(copy_tree(car(ast), &blk), copy_tree(cdr(ast), &blk))
    else
      cons(car(ast), copy_tree(cdr(ast), &blk))
    end
  end

  def map_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(map_tree(car(ast), &blk), map_tree(cdr(ast), &blk))
    else
      cons(blk.call(car(ast)), map_tree(cdr(ast), &blk))
    end
  end

  def map_inner_tree(ast, &blk)
    if !null?(ast) && pair?(ast) && atom?(car(ast))
      yield car(ast) if block_given?
    end

    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(map_inner_tree(blk.call(car(ast)), &blk), map_inner_tree(cdr(ast), &blk))
    else
      cons(car(ast), map_inner_tree(cdr(ast), &blk))
    end
  end

# get the last item in list
def last_element(sexp)
  if null?(sexp)
    sexp
  elsif null?(cdr(sexp))
    car(sexp)
  else
    last_element(cdr(sexp))
  end
end
end
  