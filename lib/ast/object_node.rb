# object_node.rb - class ObjectNode < NonTerminal - holds for eventual
# ObjectType by invoking mkobject with a bunch of PairNodes

class ObjectNode < NonTerminal
def initialize argc=0
  @argc = argc
end
  attr_reader :argc
  def self.subtree(pairs=[])
    pairs.reject!(&:nil?)
    top = mknode(self.new(pairs.length))

    pairs.each do |p|
      top << node_unless(p)
    end
    top
  end

  def emit(bc, ctx)
    bc.codes << :pushc
    bc.codes << ctx.store_constant(@argc)
    bc.codes << :pushl
    bc.codes << :mkobject
    bc.codes << :icall
  end

  def inspect
    "#{self.class.name}: argc: #{@argc}"
  end
end
