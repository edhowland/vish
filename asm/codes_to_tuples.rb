# codes_to_tuples.rb - method codes_to_tuples - converts bytecodes to [[opcode, operand], ...]


def codes_to_tuples codes
  result = []
  e = codes.each
  loop do
    code = e.next
    if has_operand? code
      operand = e.next
    end
    result << BasicOpcode.new(code, BasicOperand.new(operand))
  end
  result.map(&:to_a)
end
