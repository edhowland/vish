# pry/debug.rb - methods for debugging CodeInterpreter bytecodes

# debug_handler - returns Context (passed in) and ByteCodes
# with codes to inspect the passed in ctx and halt, then :iret
def debug_handler ctx
  bc = ByteCodes.new
  bc.codes = [:spy, :halt, :iret]
  return bc, ctx
end

def install_debug_handler ci
  ci.handlers[:_debug] = debug_handler ci.ctx
  def ci.continue
    run(bc.pc)
  end
end

def set_breakpt ci, index
  ci.bc.codes.insert(index, :int)
  ci.bc.codes.insert(index+1, :_debug)
end

def  locate_code ci, code
  ci.bc.codes.index code
end
