# opcode.rb - class Opcode opcode, operand=nil; Base for Label

class Opcode
  def initialize opcode, operand=nil
    @opcode = opcode.to_sym
    @operand = operand
    @operand.resolve!(@opcode) unless @operand.nil? # tells the operand to resolve itself, E.g. do a to_i ...
    @pc = nil
  end

  attr_reader :opcode, :operand
  attr_accessor :pc

  def to_a
    result = [self]
    result << @operand.value unless @operand.nil?
    result
  end
end