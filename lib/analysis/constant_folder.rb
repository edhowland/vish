# constant_folder.rb - class ConstantFolder - part of analysis in VishCompiler

class ConstantFolder
  include TreeUtils

  def operator?(sym)
    [:add,:sub,:mult,:div, :modulo].member? sym
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

  def op_from(sym, dict={:add => :+, :sub => :-, :mult => :*, :div => :/, :modulo => :%})
    dict[sym]
  end
  def mkInteger(ival)
    list(:integer, ival) 
  end

  # foldable? can fold_constant
  def foldable?(node)
    if null?(node)
      false
    elsif constant_node?(node)
      true
    elsif const_expr?(node)
      true
    elsif operator?(car(node))
      foldable?(cadr(node)) && foldable?(caddr(node))
    else
      false
    end
  end

  # fold_constant(node) # new version that is recursive
  def fold_constant(node)
    if constant_node?(node)
      cadr(node).to_s.to_i
    else
      op = op_from(car(node))
      fold_constant(cadr(node)).send(op, fold_constant(caddr(node)))

    end
  end

  def _fold_constant(node)
    op = op_from(car(node))

    e1 = MkConstant.new(cadr(cadr(node)))
    e2 = MkConstant.new(cadr(caddr(node)))
    e1.integer.send(op, e2.integer)
  end

  def _run(ast)
    ast
  end

def run(ast)
    if null?(ast)
      NullType.new
    elsif foldable?(ast)
      mkInteger(fold_constant(ast))
    elsif pair?(car(ast))
      cons(run(car(ast) ), run(cdr(ast)))
    else
      cons(car(ast), run(cdr(ast)))
    end
  end
end
