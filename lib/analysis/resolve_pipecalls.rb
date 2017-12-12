# resolve_pipecalls.rb - method resolve_pipecalls(AST) - Changes FunctionCall
# to increment their argc if under a PipeCall

def resolve_pipecalls(ast)
  pcalls = ast.select {|n| n.content.class == PipeCall }
  pcalls.each do |p|
    x = p.find {|e| e.content.respond_to?(:argc) }
    x && (x.content.argc += 1)
  end
end
