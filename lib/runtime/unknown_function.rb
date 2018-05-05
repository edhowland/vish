# unknown_function.rb - class UnknownFunction < RuntimeError - raised if 
# unknown Builtin function encountered.
# This shuld only occur if it is an internal compiler-generated :icall function name

class UnknownFunction < VishRuntimeError
  def initialize name
    super "Internal runtime error: Unknown Function: #{name}\nThis could occur if a version difference between compiled code and a newer Vish runtime"
  end
end
