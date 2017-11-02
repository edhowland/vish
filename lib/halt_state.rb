# halt_state.rb - class HaltState < RuntimeError - Normal early termination

class HaltState < RuntimeError
  def exit_code
    0
  end
end
