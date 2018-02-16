# lambda_exit.rb - class LambdaExit < Terminal - emits :fret opcode

class LambdaExit < Terminal
  def initialize argc=0
    @argc = argc
  end
  def emit(bc, ctx)
#    bc.codes << :vars_pop unless @argc.zero?
    bc.codes << :fret
  end
  def inspect
    "#{self.class.name}: argc: #{@argc}"
  end
end