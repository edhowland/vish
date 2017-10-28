# binary_tree_factory.rb - class BinaryTreeFactory
# constructs AST subtree given a top class and left, right nodes

class BinaryTreeFactory
  def self.subtree(klass, left, right)
    top = mknode(klass.new)
    top << mknode(left)
    top << mknode(right)
    top
  end
end
