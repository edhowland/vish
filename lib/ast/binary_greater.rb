# binary_greater.rb - class BinaryGreater < NonTerminal - 3 > 2 is true


class BinaryGreater < NonTerminal
  def emit(bc, ctx)
    bc.codes << :greater
  end
end