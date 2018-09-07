# copy_tree.rb - copies input tree, with possible changed subtree via passed
#block

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
      cons(car(ast), copy_tree(cdr(ast)))
    end
  end
  
  end
  