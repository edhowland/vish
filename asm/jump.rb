# jump.rb - class Jump < Opcode - has Target for operand

class Jump < Opcode
  def initialize opcode, target
    super opcode, Target.new(target)
  end
end