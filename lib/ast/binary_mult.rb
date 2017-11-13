# binary_mult.rb - classBinaryMult < NonTerminal 


class BinaryMult < NonTerminal
  def emit(bc, ctx)
    bc << :mult
  end
end
