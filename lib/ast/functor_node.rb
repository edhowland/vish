# functor_node.rb - class FunctorNode - .subtree(object, *list)
# In our AST, a FunctorNode creates a subtree with elements for the Funcall
# and a possibly empty args list as children

class FunctorNode
  def self.subtree(object, list=[])
  # remove any possible nils from list, put there by VishParser
  list.reject!(&:nil?)
  object.argc = list.length
    top = mknode(object)
    list.each do |a|
      top << node_unless(a)
    end
          top
  end
end