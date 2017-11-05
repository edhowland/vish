# opcode.rb - class Opcode opcode, operand=nil; Base for Label

class Opcode
  def initialize opcode, operand=nil
    @opcode = opcode.to_sym
    @operand = operand
    @operand = @operand.to_i if has_numeric_operand?(@opcode)
    @pc = nil
  end

  attr_reader :opcode, :operand
  attr_accessor :pc

  def to_a
    result = [self]
    result << @operand unless @operand.nil?
    result
  end
end