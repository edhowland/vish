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
  def op_from(sym, dict={:add => :+, :sub => :-, :mult => :*, :div => :/})
    dict[sym]
  end
  def mkInteger(ival)
    list(:integer, ival) 
  end

  def fold_constant(node)
    op = op_from(car(node))

    e1 = MkConstant.new(cadr(cadr(node)))
    e2 = MkConstant.new(cadr(caddr(node)))
    e1.integer.send(op, e2.integer)
  end


def run(ast)
    if null?(ast)
      NullType.new
    elsif const_expr?(ast)
      mkInteger(fold_constant(ast))
    elsif pair?(car(ast))
      cons(run(car(ast) ), run(cdr(ast)))
    else
      cons(car(ast), run(cdr(ast)))
    end
  end
end
