# branch_if_true.rb - class BranchIfTrue < BranchSource - opcode :jmpt

class BranchIfTrue < BranchSource
  def initialize
    super :jmpt
  end
end
