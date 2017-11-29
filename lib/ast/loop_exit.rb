# loop_exit.rb - class LoopExit < Terminal - what to do upon loop exit

class LoopExit < Terminal
  attr_reader :label, :return_to
  def emit(bc, ctx)
    bc.codes << :jmp
    @label = bc.codes.length
    bc.codes << :_loop_target
    @return_to = bc.codes.length
  end
end
