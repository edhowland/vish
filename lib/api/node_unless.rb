# node_unless.rb - method node_unless(possible_node) - creates Tree::TreeNode
# unless it is already a node

# node_unless(possible_node) : returns Tree::new TreeNode unless already one.
def node_unless(possible_node)
  possible_node.kind_of?(Tree::TreeNode) ? possible_node : mknode(possible_node)
end
