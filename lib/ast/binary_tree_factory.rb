# binary_tree_factory.rb - class BinaryTreeFactory
# constructs AST subtree given a top class and left, right nodes

class BinaryTreeFactory
  def self.subtree(klass, left, right)
    top = mknode(klass.new)
#    binding.pry
    if left.instance_of? Tree::TreeNode 
      top << left
    else
    top << mknode(left)
    end
    if right.instance_of? Tree::TreeNode
      top << right
    else
      top << mknode(right)
    end
    top
  end
end
