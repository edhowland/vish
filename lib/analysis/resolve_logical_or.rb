# resolve_logical_or.rb - method resolve_logical_or - inserts branch nodes

def resolve_logical_or(ast)
    visit_ast(ast, LogicalOr) do |node|
    target = mknode(BranchTarget.new)
    source = BranchSource.new(:jmpt)
    source.source = target.name
    node.add(mknode(source), 1)
    node << target
  end
end
