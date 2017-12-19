# function.rb - class Function < NonTerminal

class Function < NonTerminal
  def initialize name
    @name = name.to_sym
  end
  attr_reader :name
  def self.subtree(name, block, arglist=[])
    top = mknode(self.new(name))
    arglist.reject!(&:nil?)
    top << node_unless(FunctionEntry.new(arglist))
    top << node_unless(block)
    top << node_unless(FunctionExit.new())
    top
  end
  def emit(bc, ctx)
    #
  end
end