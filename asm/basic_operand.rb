# basic_operand.rb - class BasicOperand - Parent of Operand, others

class BasicOperand
  def initialize value
    @value = value
  end
  attr_reader :value

  def to_a
    @value.nil? ? [] : [self]
  end
end
