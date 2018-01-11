# buffer convert_assigned_blocks_to_lambdas.rb - method 
#convert_assigned_blocks_to_lambdas(AST)

def convert_assigned_blocks_to_lambdas(ast)
  blocks = get_assign_to_blocks(ast).map(&:last_child)
  parents = blocks.map(&:parent)
  # destructive actions below
  blocks.each(&:remove_from_parent!)
  lambdas = blocks.map {|b| Lambda.subtree([], b) }
  parents_lambdas = parents.zip(lambdas)
  parents_lambdas.each {|p, l| p << l }
end
