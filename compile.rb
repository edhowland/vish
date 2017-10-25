# compile.rb - method compile(string) - returns bytecodes, Context

require_relative 'parse'

def compile(string)
  bc = ByteCodes.new
  ctx = Context.new
  # Hand walk the AST

  ast = parse(string)
  ast.postordered_each {|n| n.content.emit(bc, ctx) }
#  ast.post_order_each { |n| n.content.emit(bc, ctx) }
  return bc, ctx
end
