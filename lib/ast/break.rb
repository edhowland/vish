# break.rb - class Break < Terminal - causes :int, :default to be emitted

class Break < Terminal
  def emit(bc, ctx)
    bc.codes << :unwind
    bc.codes << LoopFrame
    bc.codes << :bret # TODO: For now.  Eventually disambiguate this from block returns
  end
end
