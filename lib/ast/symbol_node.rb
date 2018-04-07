# symbol_node.rb - class SymbolNode < Terminal - represents Ruby symbol

class SymbolNode < Terminal
  def initialize value
    @value = value.to_s.chomp(':').to_sym
  end

  def emit(bc, ctx)
    bc.codes << :pushc
    bc.codes << ctx.store_constant(@value.to_sym)
  end
end
