# start.rb - class Start < NonTerminal - Empty AST node to act as anchor for root

class Start < NonTerminal
  def emit(bc, ctx)
    # nop
  end
end