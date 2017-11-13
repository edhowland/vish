# binary_equality.rb - class BinaryEquality < NonTerminal - emits :eq

class BinaryEquality < NonTerminal
  def emit(bc, ctx)
    bc.codes << :eq
  end
end