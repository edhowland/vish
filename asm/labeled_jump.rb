# labeled_jump.rb - class LabeledJump < Label - Is a Label, but also contains
# Target as operand

class LabeledJump < Label
  def initialize name, opcode, target
    super name, opcode, Target.new(target)
  end
end
