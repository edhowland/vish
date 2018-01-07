# return.rb - class Return < NonTerminal - Handles return keyword

class Return < NonTerminal
  # subtree (expr) - returns subtree with Return (of type) at head, expression
  # AST subtree as body
  def self.subtree(expr)
    top = mknode(self.new)
    top << node_unless(expr)
    top
  end

  def emit(bc, ctx)
    raise CompileError.new "Vish compiler error: Undifferentiated return types: Must be either BlockReturn or FunctionReturn"
  end
end

class BlockReturn < Return
  def emit(bc, ctx)
    bc.codes << :unwind
    bc.codes << BlockFrame
    bc.codes << :bret
  end
end

class FunctionReturn < Return
  def emit(bc, ctx)
    bc.codes << :unwind
    bc.codes << FunctionFrame
    bc.codes << :fret
  end
end

# LambdaReturn - emits :unwind, UnionFrame
# which checks for either MainFrame or FunctionFrame
class LambdaReturn < Return
  def emit(bc, ctx)
       bc.codes << :unwind
    bc.codes << UnionFrame
    bc.codes << :fret
  end
end
