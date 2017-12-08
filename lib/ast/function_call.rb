# function_call.rb - class FunctionCall < Terminal
# Like Funcall, but for user defined functions. See: Function, FunctionEntry,
# FunctionExit.

class FunctionCall < Terminal
  def initialize value
    @value = value.to_sym
  end
  
  def emit(bc, ctx)
    bc.codes << :fcall
    bc.codes << @value
  end
end