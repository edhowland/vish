# binary_lte.rb - class  BinaryLTE < NonTerminal - 2 < 3 is true

class BinaryLTE < NonTerminal
  def emit(bc, ctx)
    bc.codes << :lte
  end
end
