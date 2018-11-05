# opcode_error.rb - Error : OpcodeError - raised when when no opcode matches

class OpcodeError < RuntimeError
  def initialize param
    @opcode = param
    super "#{self.class.name}: Unexpected opcode #{@opcode}"
  end
  attr_reader :opcode
  def exit_code
    1
  end
end
