# vish_machine_ex.rb - class VishMachineEx - Extends VishMachine

#require_relative 'vish_machine'
#require_relative 'vish_ffi'
# Prelude stuff - Here For now 
#require_relative 'ffi_types'
#require_relative 'vish_predicates'

require_relative 'vish_prelude'





class VishMachineEx < VishMachine
  def initialize bc, ctx,  ffi=VishFFI.new(self)
    super bc, ctx
    @ffi = ffi
    # Patchy bit
    @opcodes[:icall] = ->(bc, ctx, fr, intp) {
    # get the symbol name of the builtin call
    meth = ctx.stack.pop
    # get the possible arg count
    argc = ctx.stack.pop
    argv = ctx.stack.pop(argc)
    ctx.stack.push(@ffi.send(meth, *argv))
    }
    @opcodes[:fret] = ->(bc, ctx, fr, intp) {
      frame = fr.pop
      ret_val = frame.ctx.stack.safe_pop
      #fr
      intp.ctx.stack.push ret_val
      bc.pc = frame.return_to
    }
  end
  attr_reader :ffi


end
