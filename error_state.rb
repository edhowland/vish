# error_state.rb - class ErrorState < RuntimeError - something went horibly wrong
# These might be raised in bcode lambdas or there might be an a special :error bcode
# This thing might be the target of an jmp instruction

class ErrorState < RuntimeError
  def initialize param
    super "#{self.class.name}: #{param}"
  end

  def exit_code
    0xff
  end
end
