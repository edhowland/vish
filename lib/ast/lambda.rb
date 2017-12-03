# lambda.rb - class Lambda < NonTerminal
class Lambda < NonTerminal
  # subtree - constructs a subtree of nodes: LambdaEntry, Block, LambdaExit
  # Parameters:
  # arglist - Array - list of (string literals)? - passed to LambdaEntry
  # body - Block of AST nodes making up body of function
  def self.subtree(arglist, body)
    top = mknode(self.new)
    top << mknode(LambdaEntry.new(arglist))
    top << node_unless(body)
    top << mknode(LambdaExit.new)

    top
  end

  def emit(bc, ctx)
    # nop
  end
end
