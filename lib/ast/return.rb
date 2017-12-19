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
    bc.codes << BlockFrame.new
    bc.codes << :bret
  end
end

class FunctionReturn < Return
  def emit(bc, ctx)
    bc.codes << :unwind
    bc.codes << FunctionFrame.new(Context.new)
    bc.codes << :fret  # TODO: Change this to really deactivate FunctionFrame at top of ctx.call_stack
  end
end