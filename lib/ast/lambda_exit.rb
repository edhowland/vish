# lambda_exit.rb - class LambdaExit < Terminal - emits :fret opcode

class LambdaExit < Terminal
  def emit(bc, ctx)
    bc.codes << :fret
  end
end