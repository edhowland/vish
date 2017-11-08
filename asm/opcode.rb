# opcode.rb - class Opcode< BasicOpcode (opcode, operand=nil); Base for Label

class Opcode < BasicOpcode
  def initialize opcode, operand=nil
    super opcode, operand
  end

  def to_a
    result = [self]
    result << @operand.value unless @operand.nil?
    result
  end
end