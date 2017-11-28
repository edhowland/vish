# return.rb - class Return < NonTerminal - Handles return keyword

class Return < NonTerminal
  def self.subtree(expr)
    top = mknode(self.new)
    top << node_unless(expr)
    top
  end

  def emit(bc, ctx)
    bc.codes << :bret
  end
end