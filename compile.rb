# compile.rb - method compile(string) - returns bytecodes, Context

def compile(string)
  bc = ByteCodes.new
  ctx = Context.new
  # Hand walk the AST
  # for this expression/statement
  # result = 1 + 34
  num_1 = Numeral.new(1)
  num_34 = Numeral.new(34)
  num_1.emit(bc, ctx)
  num_34.emit(bc, ctx)
  adder = BinaryAdd.new
  adder.emit(bc, ctx)
  #var_1 = LValue.new('result')
  #var_1.emit(bc, ctx)

  return bc, ctx
end
