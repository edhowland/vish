# operand.rb - class Operand < BasicOperand; sibling of Target

class Operand < BasicOperand
  def initialize value
    super value
    @value = value.to_s

    @line, @col = value.line_and_column
  end
  attr_reader :line, :col

  def resolve! opcode
    if has_numeric_operand?(opcode)
      @value = @value.to_i
    end
  end
end
