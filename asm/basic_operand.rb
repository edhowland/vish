# basic_operand.rb - class BasicOperand - Parent of Operand, others

class BasicOperand
  def initialize value
    @value = value.to_s
  end
  attr_reader :value
end
