# binary_less.rb - class BinaryLess - 2 < 3 inequality

class BinaryLess < NonTerminal
  def emit(bc, ctx)
    bc.codes << :less
  end
end
