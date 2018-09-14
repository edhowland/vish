# constant_folder.rb - class ConstantFolder - part of analysis in VishCompiler

class ConstantFolder
  include TreeUtils

  def operator?(sym)
    [:add,:sub,:mult,:div].member? sym
  end
  # Add additional types here: :boolean, :string
  def constant?(sym)
    [:integer].member? sym
  end

  # constant_node?(node)
  def constant_node?(node)
    constant?(car(node))
  end

  def const_expr?(node)
    operator?(car(node)) && constant_node?(cadr(node)) && constant_node?(caddr(node))
  end
  # constant or constant expression
  def constant_or_constant_expr?(node)
    constant_node?(node) || const_expr?(node)
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
