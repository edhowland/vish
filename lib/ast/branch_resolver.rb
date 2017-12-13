# branch_resolver.rb - class BranchResolver.subtree(klass, left, right)
# This set of nodes in a subtree gets resolved after the emit_walker phase.
# an object of type BranchSource is placed after  left, before right.
# Its actual emission is :jmp{t,f}, :_UNKNOWN_TARGET
# and an object of type BranchTarget is placed after right. Its emission stores bc.codes.length, is stored
# This class holds references to  both of these 
# When finally, the target_resolver is run on the whole AST, the actual 
# jump target  is placed in the BranchSource source location in bc.codes[index].

class BranchResolver
  def initialize klass
    @source = klass.new
    @target = BranchTarget.new
  end
  attr_reader :source, :target
    # where the majik happens
  def subtree(left, right)
    top = mknode(self)
    top << node_unless(left)
    top << mknode(@source)
    top << node_unless(right)
    top << mknode(@target)

    top
  end

  # since this emit happens after the subtree when walked in post_order, depth first 
  # we have enough information to repair the :_UNKNOWN_TARGET
  def emit(bc, ctx)
    bc.codes[@source.source] = @target.target
  end

  def inspect
    self.class.name
  end
end
