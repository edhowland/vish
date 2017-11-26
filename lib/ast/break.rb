# break.rb - class Break < Terminal - causes :int, :default to be emitted

class Break < Terminal
  def emit(bc, ctx)
    bc.codes << :int
    bc.codes << :_default
  end
end
