# unary_negative.rb - class UnaryNegative < NonTerminal - arithmetic expression
# including negative integers

class UnaryNegative < NonTerminal
  def emit(bc, ctx)
    bc.codes << :negate
  end
end
