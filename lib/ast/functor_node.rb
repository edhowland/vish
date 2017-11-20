# functor_node.rb - class FunctorNode - .subtree(object, *list)
# In our AST, a FunctorNode creates a subtree with elements for the Funcall
# and a possibly empty args list as children

class FunctorNode
  def self.subtree(object, list=[])
  object.argc = list.length
    top = mknode(object)
    list.each do |a|
      if a.instance_of?(Tree::TreeNode)
        top << a
      else
        top << mknode(a)
      end
    end
          top

  end
end