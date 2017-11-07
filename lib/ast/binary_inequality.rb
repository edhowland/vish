# binary_inequality.rb - class BinaryInequality < NonTerminal - emits :neq


class BinaryInequality < NonTerminal
  def emit(bc, ctx)
    bc.codes << :neq
  end
end