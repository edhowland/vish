# branch_source.rb - class BranchSource - base class of BranchIfTrue, BranchIfFalse

class BranchSource
  def initialize opcode
    @opcode = opcode
    @source = :_UNKNOWN_TARGET
    @operand = -1
  end
  attr_reader :opcode
  attr_accessor :source, :operand

  def emit(bc, ctx)
    bc.codes << @opcode
    bc.codes << @source
    @operand = bc.codes.length - 1
  end
  def inspect
    self.class.name + ": opcode: #{@opcode} source: #{@source}"
  end
end
