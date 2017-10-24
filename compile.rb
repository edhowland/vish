# compile.rb - method compile(string) - returns bytecodes, Context

require_relative 'parse'

def compile(string)
  bc = ByteCodes.new
  ctx = Context.new
  # Hand walk the AST
  #var_1 = LValue.new('result')
  #var_1.emit(bc, ctx)

  ast = parse(string)
  ast.each { |n| n.emit(bc, ctx) }
  return bc, ctx
end
