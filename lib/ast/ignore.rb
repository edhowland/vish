# ignore.rb - class Ignore < Terminal - Handles the empty parse node

class Ignore < Terminal
  def emit(bc, ctx)
    # nop
  end
  def inspect
    self.class.name
  end
end
