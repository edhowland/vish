# resolve_logical_and.rb - method cresolve_logical_and - inserts branch nodes

# resolve_logical_and - for every LogicalAnd node, insert a pair of  
# BranchSource/BranchTarget nodes. The former will have a reference to the
# latter.
# Will get resolved after code generation
# Parameters:
# ast : The root of the AST tree
def resolve_logical_and(ast)
  visit_ast(ast, LogicalAnd) do |node|
    target = mknode(BranchTarget.new)
    source = BranchSource.new(:jmpf)
    source.source = target.name
    node.add(mknode(source), 1)
    node << target
  end
end