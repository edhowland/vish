# boolean_and.rb - class BooleanAnd < NonTerminal - emits :and

class BooleanAnd < NonTerminal
  def emit(bc, ctx)
    bc.codes << :and
  end
end
