# pair_node.rb - class PairNode < NonTerminal - creates PairType tuple for
# object key/value pair

class PairNode < NonTerminal
  def initialize symbol
    @symbol = symbol
  end
  attr_reader :symbol
  # subtree(symbol, expression) - builds subtree of this node type and
  # symbol and extression subtree as child nodes
  def self.subtree(symbol, expr)
    this = mknode(self.new(symbol))
    this << node_unless(symbol)
    this << node_unless(expr)

    this
  end

  def emit(bc, ctx)
    bc.codes << :pushl
    bc.codes << 2
    bc.codes << :pushl
    bc.codes << :mkpair
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}: symbol: #{@symbol.inspect}"
  end
end