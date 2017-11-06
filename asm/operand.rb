# operand.rb - class Operand sibling of Target

class Operand
  def initialize value
    @value = @value.to_s
    @line, @col = value.line_and_column
  end
  attr_reader :value, :line, :col
  
  def resolve! opcode
    if has_numeric_operand?(opcode)
      @value = @value.to_i
    end
  end
end
