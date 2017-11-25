# block_exit.rb - class BlockExit < Terminal - tail half of  Block surround
# pair. This applies after a block has been detached from the AST proper.
# It performs a :bret call to return to the call stack

class BlockExit < Terminal
  def emit(bc, ctx)
    bc.codes << :bret
  end
end
