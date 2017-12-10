# function_exit.rb - class FunctionExit < Terminal

class FunctionExit < Terminal
  def emit(bc, ctx)
    bc.codes << :fret
  end
end