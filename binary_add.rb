# binary_add.rb - class BinaryAdd - Operator - just emit :add to bytecodes

class BinaryAdd < NonTerminal
  def emit(bc, ctx)
    bc << :add
  end
end
