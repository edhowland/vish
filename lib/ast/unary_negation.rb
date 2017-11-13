# unary_negation.rb - class UnaryNegation < NonTerminal - emits :not for '! 0'


class UnaryNegation < NonTerminal
  def emit(bc, ctx)
    bc.codes << :not
  end
end