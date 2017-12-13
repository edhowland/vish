# visit_ast.rb - method visit_ast(ast, Klass) - visits certain nodes, performs
# block on them. Also, find_node(ast, name)

def visit_ast(ast, klass, &blk)
  ast.select {|n| n.content.class == klass }.each(&blk)
end

# find_ast_node - finds a specified node by name
def find_ast_node(ast, name)
  ast.find {|n| n.name == name }
end
