# emit_walker.rb - method emit_walker AST - from ProgramFactory.tree

def emit_walker ast, ctx = Context.new
  bc = ByteCodes.new

  ast.postordered_each {|n| n.content.emit(bc, ctx) }
  return bc, ctx
end
