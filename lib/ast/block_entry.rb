# block_entry.rb - class BlockEntry < Terminal 
# - emits value of bc.pc in ctx.vars  an external block

# class BlockEntry < Terminal
# stashes the current program counter in parents value name: _block_assign: blah, blah
# Expects to be initialized with parent Block.value
class BlockEntry < Terminal
  def emit(bc, ctx)
    ctx.vars[@value.to_sym] = bc.codes.length
  end
end
