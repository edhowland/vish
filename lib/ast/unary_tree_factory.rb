# unary__tree_factory.rb - class UnaryTreeFactory .subtree(Unary...klass, node)

class UnaryTreeFactory
  def self.subtree(klass, right)
    top = mknode(klass.new)
    if right.instance_of? Tree::TreeNode
      top << right
    else
      top << mknode(right)
    end
    top
  end
end
