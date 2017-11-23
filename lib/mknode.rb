# mknode.rb - method mknode


$node_name = 0
def mknode(value, name=sprintf('%04d', $node_name))
  $node_name += 1
  name="#{value.class.name}:#{$node_name}"
    Tree::TreeNode.new(name, value)
end

