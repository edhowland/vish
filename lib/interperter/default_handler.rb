# default_handler - method default_handler - returns new ByteCodes, Context
# preloaded with code to run if opcode, operand is [:int, :_default]

def default_handler
  bc = ByteCodes.new
  bc.codes = [:pushc, 0, :print, :halt]
  ctx = Context.new
  ctx.constants = ['Default interrupt handler called. Terminiting']
  return bc, ctx
end