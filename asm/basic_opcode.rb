# basic_opcode.rb - class BasicOpcode - parent of Opcode, others

class BasicOpcode
  def initialize opcode, operand=nil
    @opcode = opcode.to_sym
    @operand = operand
    @pc = nil    
  end
  attr_reader :opcode, :operand
  attr_accessor :pc

  def to_a
    self.send(which?(@operand), self, @operand)
  end
  # protected methods to pattern on match for to_a above
  protected
  def which?(operand)
    {
      NilClass => :to_a_1,
      Fixnum => :to_a_2,
      String => :to_a_2
    }[operand.value.class]
  end
  def to_a_1 opcode, operand
    [opcode]
  end
  def to_a_2 opcode, operand
    [opcode, operand]
  end
end
