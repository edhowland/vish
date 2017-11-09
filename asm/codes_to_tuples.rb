# codes_to_tuples.rb - method codes_to_tuples - converts bytecodes to [[opcode, operand], ...]

module Targetable
  def to_s
    ":#{'lbl%05d' % @pc} #{@opcode.to_s}"
  end
end

module Jumpable
  def to_a
    [self, BasicOperand.new(':lbl%05d' % @operand.value)]
  end
end


def codes_to_tuples codes
  result = []
  a = (0...codes.length).to_a
  e = codes.each
  f = a.each
  loop do
    code = e.next
    pc = f.next
    if has_operand? code
      operand = e.next
      _dummy = f.next
    end
    result << BasicOpcode.new(code, BasicOperand.new(operand), pc)
  end

  result.select {|c| c.opcode.to_s[0..2] == 'jmp' }.each {|c| c.extend Jumpable; t = result.find {|f| f.pc == c.operand.value }; t.extend Targetable  }

  result.map(&:to_a)
end
