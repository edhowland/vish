# visit_ast.rb - method visit_ast(ast, Klass) - visits certain nodes, performs
# block on them. Also, find_node(ast, name)
# Also, select_class(ast, klass) - returns array of nodes that match node.content.class

def visit_ast(ast, klass, &blk)
  ast.select {|n| n.content.class == klass }.each(&blk)
end

# find_ast_node - finds a specified node by name
def find_ast_node(ast, name)
  ast.find {|n| n.name == name }
end


def select_class(ast, klass)
  ast.select {|n| n.content.class == klass }
end


def grandparent(node)
  node.parent.parent
end

def add_uncle(node, object)
  g = grandparent(node)
  offset = g.children.index node.parent
  g.add(node_unless(object), offset)
end
