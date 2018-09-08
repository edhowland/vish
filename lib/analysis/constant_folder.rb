# constant_folder.rb - class ConstantFolder - part of analysis in VishCompiler

class ConstantFolder
  include TreeUtils

  def operator?(sym)
    [:add,:sub,:mult,:div].member? sym
  end

  def constant?(sym)
    [:integer].member? sym
  end

  def const_expr?(node)
    operator?(car(node)) && constant?(car(cadr(node))) && constant?(car(caddr(node)))
  end
def _run(ast)
    if null?(ast)
      NullType.new
    elsif pair?(car(ast))
      cons(copy_tree(car(ast), &blk), copy_tree(cdr(ast), &blk))
    else
      cons(car(ast), copy_tree(cdr(ast)))
    end

end
  def run(ast)
    copy_tree(ast)
  end
end
