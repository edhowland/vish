# vector_id.rb - class VectorId < NonTerminal - holds ref to vector subscript
# for deref purposes. E.g. a=[0,1,2]; a[1]=9;:a # => [0,9,2]

class VectorId < NonTerminal
  def self.subtree(id, index)
    top = mknode(self.new)
    top << node_unless(id)
    top << node_unless(index)

    top
  end
  def emit(bc, ctx)
    # nop
  end
  def inspect
    "#{self.class.name}"
  end
end
