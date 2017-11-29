# loop.rb - class Loop < NonTerminal - creates subtree AST nodes for loop block


# class Loop - head node of loop { ... } loop block
# methods:
# emit(bc, ctx) - handles label fix up after subtree nodes have been emitted
#
# attributes:
# :loop_entry - the saved LoopEntry node
# :loop_exit - the LoopExit node
# :loop_frame - the LoopFrame pushed on the ctx.call_stack
class Loop < NonTerminal
  attr_accessor :loop_entry, :loop_exit, :loop_frame
  def emit(bc, ctx)
    bc.codes[@loop_exit.label] = @loop_entry.jump_to
    @loop_entry.loop_frame.return_to = @loop_exit.return_to
  end

  # subtree - constructs subtree with LoopEntry, subtree(a block), LoopExit
  def self.subtree(block)
  loop = self.new
    loop.loop_exit = LoopExit.new
    loop.loop_entry = LoopEntry.new

    top = mknode(loop)
    top << mknode(loop.loop_entry)
    top << node_unless(block)
    top << mknode(loop.loop_exit)
    top
  end
end
