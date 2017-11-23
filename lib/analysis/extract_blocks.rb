# extract_blocks.rb - method extract_blocks(ast) - returns new ast and
# list of blocks extracted from them

# Strategy
# Get all the blocks in AST : .select {|n| ...
# Convert this array with map(&:path_as_array)
# select on the new array where the [-2] =~ /^Assign/
#  map this final array into |e| e[-1] . Getting the node.names that are unique
#   of Blocks.
# Grab these nodes from the AST[block_name].
#
# Now we have a list of actual Tree::TreeNodes.
# Remove them from their parents
# make a new new StringLiteral from Block.unique name
# attach this to right of Assign node
# Now the assign looks in code like:
#  name='_block_0F4ABC'
# emit_walker on all of these blocks and store in CodeContainer s.
# Preload the root Context.vars key=this block name, value is the CodeContainer


# get_assign_to_blocks ast -  returns array of Assign nodes
def get_assign_to_blocks(ast, &blk)
  blocks = ast.select {|n| n.name =~ /^Block/ }
  paths = blocks.map(&:path_as_array)
  assign_blocks = paths.select {|e| e[-2] =~ /^Assign/ }
  assigns = assign_blocks.map {|e| e[-2] }.map {|e| ast[e] }

end

# extract_assign_blocks ast - removes blocks from get_assign_blocks assign
# parents. Returns self-same blocks.
def extract_assign_blocks(ast)
  assigns = get_assign_to_blocks(ast)
  blocks = assigns.map(&:last_child)
  blocks.each {|b| b.content.value = "_block_#{b.parent.name}"; b.content.from = b.parent.name }

  # Destructors here below!
  blocks.map!(&:remove_from_parent!)
  blocks.each do |b|
    parent = ast[b.content.from]
    parent << mknode(StringLiteral.new(b.content.value))
  end
  blocks
end