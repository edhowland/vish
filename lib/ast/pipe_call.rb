# pipe_call.rb - class PipeCall - like FunctionCall but adds one to argc


class PipeCall < NonTerminal
  def self.subtree(node)
    top = mknode(self.new)
    top << node_unless(node)
    top
  end

  # emit  code to ensure top of current stack is available as first arg to 
  # function call
  def emit(bc, ctx)
    #
  end
  def inspect
    self.class.name
  end
end