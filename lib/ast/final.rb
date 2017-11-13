# final.rb - class Final < Terminal - Last state of the FSM

class Final < Terminal
  def emit(bc, ctx)
    bc << :print  # prints out the last thing of the stack
    bc << :halt  # Normal termination
  end
end
