# opcode_error.rb - Error : OpcodeError - raised when when no opcode matches

class OpcodeError < RuntimeError
  def initialize param
    super "#{self.class.name}: Unexpected opcode #{param}"
  end
  def exit_code
    1
  end
end
