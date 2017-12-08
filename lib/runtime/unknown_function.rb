# unknown_function.rb - class UnknownFunction < RuntimeError - raised if 
# unknown Builtin function encountered.

class UnknownFunction < RuntimeError
  def initialize name
    super "Unknown Function: #{name}"
  end
end
