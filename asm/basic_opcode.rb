# basic_opcode.rb - class BasicOpcode - parent of Opcode, others

class BasicOpcode
  def initialize opcode, operand=nil
    @opcode = opcode.to_sym
    @operand = operand
    @operand.resolve!(@opcode) unless @operand.nil? # tells the operand to resolve itself, E.g. do a to_i ...
    @pc = nil    
  end
  attr_reader :opcode, :operand
  attr_accessor :pc

end
