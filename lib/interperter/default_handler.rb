# default_handler - method default_handler - returns new ByteCodes, Context
# preloaded with code to run if opcode, operand is [:int, :_default]

# exit_handler - returns ByteCodes, Context wherein just :halt exit handler is installed
def exit_handler
  bc = ByteCodes.new
  ctx = Context.new
  bc.codes = [:exit]
  return bc, ctx
end

# default_handler - returns new ByteCodes, Context wherein default interrrupt handler is installed
def default_handler
  bc = ByteCodes.new
  bc.codes = [:pushc, 0, :print, :halt]
  ctx = Context.new
  ctx.constants = ['Default interrupt handler called. Terminiting']
  return bc, ctx
end
