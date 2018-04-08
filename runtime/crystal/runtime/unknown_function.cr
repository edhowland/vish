# unknown_function.rb - class UnknownFunction < RuntimeError - raised if 
# unknown Builtin function encountered.

class UnknownFunction < VishRuntimeError
  def initialize name
    super "Unknown Function: #{name}"
  end
end
