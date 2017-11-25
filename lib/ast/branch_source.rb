# branch_source.rb - class BranchSource - base class of BranchIfTrue, BranchIfFalse

class BranchSource
  def initialize opcode
    @opcode = opcode
    @source = :_UNKNOWN_TARGET
  end
  attr_reader :opcode
  attr_accessor :source
  def emit(bc, ctx)
    bc.codes << @opcode
    bc.codes << @source
    @source = bc.codes.length - 1
  end
  def inspect
    self.class.name
  end
end
