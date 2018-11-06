# vish_machine_ex.rb - class VishMachineEx - Extends VishMachine

require_relative 'vish_machine'
require_relative 'vish_ffi'
# Prelude stuff - Here For now 
require_relative 'ffi_types'



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
  end
  attr_reader :ffi


end
