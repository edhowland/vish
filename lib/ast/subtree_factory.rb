# subtree_factory.rb - class  SubtreeFactory < NonTerminal - returns new subtree
# constructed from a class and a child subtree

class SubtreeFactory
  def self.subtree klass, subtree
    top = mknode(klass.new)
    child = case subtree
    when Tree::TreeNode
      subtree
    else
      mknode(subtree)
    end
    top << child
    top
  end
end
