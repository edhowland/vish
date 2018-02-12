# lambda.rb - class Lambda < NonTerminal
class Lambda < NonTerminal
  def initialize arglist=[]
    @arglist = arglist
  end
  attr_reader :arglist

  # subtree - constructs a subtree of nodes: LambdaEntry, Block, LambdaExit
  # Parameters:
  # arglist - Array - list of (string literals)? - passed to LambdaEntry
  # body - Block of AST nodes making up body of function
  def self.subtree(arglist, body)
    arglist.reject!(&:nil?)
    argsyms = arglist.map {|a| a.value.to_sym }
    this = self.new(arglist)
    top = mknode(this)
    top << mknode(LambdaEntry.new(arglist))
    _body = node_unless(body)
    top <<  _body
    top << mknode(LambdaExit.new)

    top
  end

  def emit(bc, ctx)
    # nop
  end

  def inspect
    "#{self.class.name}: arglist: #{@arglist.map(&:inspect)}"
  end
end
