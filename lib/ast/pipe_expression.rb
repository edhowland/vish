# pipe_expression.rb - class PipeExpression - holds left and right components
# of a piped call: cmd1 | cnd2

class PipeExpression < NonTerminal
  def self.subtree(left, right)
    top = mknode(self.new)
    top << node_unless(left)
    top << PipeCall.subtree(right)
    top
  end
  def emit(bc, ctx)
      end
  def inspect
    self.class.name
  end
end