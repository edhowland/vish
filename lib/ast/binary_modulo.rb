# binary_modulo.rb - class  BinaryModulo < NonTerminal - emits %


class BinaryModulo < NonTerminal
  def emit(bc, ctx)
    bc.codes << :mod
  end
end