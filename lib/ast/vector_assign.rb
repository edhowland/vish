# vector_assign.rb - class VectorAssign < NonTerminal - assigns value of
#expression to subscript of variable. E.g. a[0]=9

class VectorAssign < NonTerminal
  def emit(bc, ctx)
        argc = ctx.store_constant(3)
    bc.codes << :pushc
    bc.codes << argc
    bc.codes << :pushl
    bc.codes << :ax
    bc.codes << :icall
  end
end
