# boolean_or.rb - class BooleanOr < NonTerminal - emits :or

class BooleanOr < NonTerminal
  def emit(bc, ctx)
    bc.codes << :or
  end
end