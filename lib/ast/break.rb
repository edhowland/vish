# break.rb - class Break < Terminal - causes :int, :default to be emitted

class Break < Terminal
  def emit(bc, ctx)
    bc.codes << :unwind
    bc.codes << LoopFrame
    bc.codes << :bret
  end
end
