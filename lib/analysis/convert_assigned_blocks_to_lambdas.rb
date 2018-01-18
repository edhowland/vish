# buffer convert_assigned_blocks_to_lambdas.rb - method 
#convert_assigned_blocks_to_lambdas(AST)

# convert_assigned_blocks_to_lambdas(AST)
# Find the blocks  which are the last child of Assign nodes
# Get their parents. I.e. the Assign nodes
#  Remove the blocks from their parents
# Convert the blocks into Lambdas
# Zip the parents and lambdas into tuples of [parent, lambda]
# Add each lambda into the last child of each parent assign
def convert_assigned_blocks_to_lambdas(ast)
  blocks = get_assign_to_blocks(ast).map(&:last_child)
  parents = blocks.map(&:parent)
  # destructive actions below
  blocks.each(&:remove_from_parent!)
  lambdas = blocks.map {|b| Lambda.subtree([], b) }
  parents_lambdas = parents.zip(lambdas)
  parents_lambdas.each {|p, l| p << l }
end


# convert_block_parameters_to_lambdas
def convert_block_parameters_to_lambdas(ast, klass=Funcall)
  funcalls = select_class(ast, klass).
    select {|f| f.children.any? {|c| c.content.class == Block } }
    funcalls.each do |f|
      f.children.each_with_index do |p, i|
        if p.content.class == Block
          b = p
          p.replace_with(mknode(Object.new))
          l = Lambda.subtree([], b)
          f.children[i].replace_with(l)
        end
      end
    end
end
