# branch_target.rb - class BranchTarget - Invisible node. emit just saves loc

class BranchTarget
  attr_accessor :target
  def emit(bc, ctx)
    @target = bc.codes.length # target is right after this location
  end
  def inspect
    self.class.name
  end
end
